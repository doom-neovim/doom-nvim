#!/usr/bin/env bash

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

DOOM_REPO_URL="https://github.com/NTBBloodbath/doom-nvim"
declare -r DOOM_CONFIG_DIR="${DOOM_CONFIG_DIR:-"$XDG_CONFIG_HOME/nvim"}"

declare BASEDIR
BASEDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASEDIR="$(dirname -- "$(dirname -- "$BASEDIR")")"
readonly BASEDIR

RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
NC=$(tput sgr0) # No Color

function help() {
  echo "Usage: install.sh [<options>]"
  echo "Automatically installs doom-nvim to your machine."
  echo ""
  echo "Options:"
  echo "    -h, --help                               Print this message"
  echo "    -y, --yes                                Skip all prompts"
}

declare -a system_dependencies=("nvim" "git" "node" "npm" "fd;optional" "rg;optional" "wget;optional" "unzip;optional")
declare -a npm_dependencies=("tree-sitter")

function banner() {
    echo "                                                                              "
    echo "=================     ===============     ===============   ========  ========"
    echo "\\\\ . . . . . . .\\\\   //. . . . . . .\\\\   //. . . . . . .\\\\  \\\\. . .\\\\// . . //"
    echo "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||"
    echo "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||"
    echo "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||"
    echo "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||"
    echo "||. . ||   ||-'  || ||  \`-||   || . .|| ||. . ||   ||-'  || ||  \`|\\_ . .|. .||"
    echo "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ \`-_/| . ||"
    echo "||_-' ||  .|/    || ||    \\|.  || \`-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||"
    echo "||    ||_-'      || ||      \`-_||    || ||    ||_-'      || ||   | \\  / |  \`||"
    echo "||    \`'         || ||         \`'    || ||    \`'         || ||   | \\  / |   ||"
    echo "||            .===' \`===.         .==='.\`===.         .===' /==. |  \\/  |   ||"
    echo "||         .=='   \\_|-_ \`===. .==='   _|_   \`===. .===' _-|/   \`==  \\/  |   ||"
    echo "||      .=='    _-'    \`-_  \`='    _-'   \`-_    \`='  _-'   \`-_  /|  \\/  |   ||"
    echo "||   .=='    _-'          \`-__\\._-'         \`-_./__-'         \`' |. /|  |   ||"
    echo "||.=='    _-'                                                     \`' |  /==.||"
    echo "=='    _-'                        N E O V I M                         \\/   \`=="
    echo "\\   _-'                                                                \`-_   /"
    echo " \`''                                                                      \`\`'  "
}

function executable_exists () {
  if ! command -v "$1" &>/dev/null; then
    return 0
  fi
  return 1
}

function check_dependency_group () {
  local dependency_group_name=$1
  local install_message=$2
  shift
  shift
  echo "Checking $dependency_group_name dependencies..."
  local missing_dependencies=0
  for i in "$@"; do
    # The recommended changes break the string splitting
    # shellcheck disable=2206
    local split_result=(${i//;/ })
    local executable="${split_result[0]}"
    local optional=${split_result[1]}

    executable_exists "${executable}"
    local dependency_status=$?

    if [ $dependency_status -eq 1 ]; then
      echo "$GREEN    [*]$NC Found \"$executable\"."
    else
      missing_dependencies=1
      if [ "$optional" = "optional" ]; then
        echo "$YELLOW    [ ]$NC Could not find optional dependency \"$executable\"."
      else
        echo "$RED    [ ]$NC Could not find dependency \"$executable\"."
      fi
    fi
  done

  if [ $missing_dependencies -eq 1 ]; then
    echo "Missing dependencies detected.  Optional dependencies can be ignored but may be necessary for some modules."
    echo "$install_message"
  fi
  echo " "
}

function backup_existing_config() {
  if [ -d "$DOOM_CONFIG_DIR" ]; then
    echo "${YELLOW}Warning:$NC There is already a config at $DOOM_CONFIG_DIR."
    echo " "
    echo "Do you want to continue installing doom-nvim? (y/n)"
    echo "Note: The old config will be backed up to ${XDG_CONFIG_HOME}/nvim-old"
    echo " "
    read -p "" -n 1 -r
    echo " "   # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # If nvim-old directory doesn`t exist, move `nvim/` to `nvim-old/'
      if [ ! -d "${XDG_CONFIG_HOME}/nvim-old" ]; then
        mv "${XDG_CONFIG_HOME}/nvim" "${XDG_CONFIG_HOME}/nvim-old"
        echo "Moved old config from \`${XDG_CONFIG_HOME}/nvim\` to \`${XDG_CONFIG_HOME}/nvim-old\`"
      else
        # If it already exists try placing it in `nvim-old-1/` then `nvim-old-2/` (up until 10)
        local i=1
        local has_found_directory=0
        while [[ $has_found_directory -eq 0 &&  $i -lt 10 ]]; do
          i=$((i+1))
          has_found_directory=$([ -d "${XDG_CONFIG_HOME}/nvim-old-${i}" ])
        done

        if [[ $has_found_directory -eq 1 ]]; then
          mv "${XDG_CONFIG_HOME}/nvim" "${XDG_CONFIG_HOME}/nvim-old-${i}"
          echo "Moved old config from \`${XDG_CONFIG_HOME}/nvim\` to \`${XDG_CONFIG_HOME}/nvim-old-${i}\`"
        fi
      fi
    fi
  fi
  echo " "
}

function install_doom_nvim() {
  echo "Cloning..."
  git clone "$DOOM_REPO_URL" "${DOOM_CONFIG_DIR}" --depth=10
  cd "${DOOM_CONFIG_DIR}" || exit
  # Setup user with their own custom branch
  git checkout -b my-config

  # Checkout the latest version if there are no uncommitted changes
  # NOTE: There shouldn't ever be uncommitted changes on a freshly cloned repo
  # but I still don't want to risk the possibility of destroying someone's code.
  local is_dirty=0
  git diff-index --quiet HEAD -- || is_dirty=1;

  echo " "
  if [ $is_dirty -eq 0 ]; then
    local tag
    tag="$(git tag -l --sort -version:refname | head -n 1)"
    git reset --hard "$tag"
    echo "${GREEN}Installed doom-nvim ${tag}!"
  else
    echo "${GREEN}Installed doom-nvim!"
    echo "${YELLOW}Warn: Could not checkout latest tag due to uncommitted changes.  \`:DoomUpdate\` command may not work."
  fi

}

function main() {
  banner

  check_dependency_group "system" "Install missing dependencies using your operating system's package manager (brew/pacman/apt-get/dnf/...)." "${system_dependencies[@]}"
  check_dependency_group "npm" "Install missing dependencies using npm/yarn/pnpm." "${npm_dependencies[@]}"

  backup_existing_config
  install_doom_nvim

  echo "Run \`nvim\` in your terminal to start doom-nvim."
}

main "$@"
