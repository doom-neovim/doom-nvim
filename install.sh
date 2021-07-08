#!/usr/bin/env bash
#================================================
# install.sh - Doom Nvim Installation Script
# Author: NTBBloodbath
# License: GPLv2
#================================================

# Terminal Colors
# ===============
# {{{
Color_reset='\033[0m' # Reset

## Normal colors
Black='\033[0;30m'  # Black
White='\033[0;37m'  # White
Red='\033[0;31m'    # Red
Blue='\033[0;34m'   # Blue
Cyan='\033[0;36m'   # Cyan
Purple='\033[0;35m' # Purple
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow

## Bold colors
BBlack='\033[1;30m'  # Black
BWhite='\033[1;37m'  # White
BRed='\033[1;31m'    # Red
BBlue='\033[1;34m'   # Blue
BCyan='\033[1;36m'   # Cyan
BPurple='\033[1;35m' # Purple
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
# }}}

# Doom Nvim version
DoomNvimVersion='2.3.5'
# System OS
System="$(uname -s)"

# Terminal Output
# ===============
# {{{
log() {
    printf '%b\n' "$1" >&2
}

log_success() {
    log "${Green}[✔]${Color_reset} ${1}${2}"
}

log_info() {
    log "${Blue}[+]${Color_reset} ${1}${2}"
}

log_error() {
    log "${Red}[×]${Color_reset} ${1}${2}"
    exit 1
}

log_warn() {
    log "${Yellow}[!]${Color_reset} ${1}${2}"
}

pretty_echo() {
    printf '%b\n' "$1$2$Color_reset" >&2
}
# }}}

# Check requirements
# ==================
# {{{
need_cmd() {
    if ! hash "$1" &>/dev/null; then
        log_error "Need '$1' (command not found)"
        exit 1
    fi
}

check_cmd() {
    if ! type "$1" &>/dev/null; then
        log_warn "Need '$1' (command not found)"
    fi
}

check_all() {
    # Install Doom Nvim (see also git)
    need_cmd 'curl'
    # Clone repositories and install Doom Nvim
    need_cmd 'git'
    # Generate help tags
    check_cmd 'ctags'
    # Install Language Server Protocols
    check_cmd 'npm'
    check_cmd 'node'
}

check_requirements() {
    log_info "Checking requirements"

    # Checks if git is installed again
    if hash "git" &>/dev/null; then
        git_version=$(git --version)
        log_success "Check requirements : ${git_version}"
    else
        log_warn "Check requirements : git"
    fi

    # Checks if neovim is installed
    if hash "nvim" &>/dev/null; then
        log_success "Check requirements : nvim"
    else
        log_warn "Check requirements : nvim"
    fi

    # Check if nodejs and npm are installed again,
    # we do not check only nodejs because some Linux distributions
    # installs nodejs but not also npm
    if hash "node" &>/dev/null; then
        log_success "Check requirements : node"
    else
        log_warn "Check requirements : node (optional, required to use LSP)"
    fi
    if hash "npm" &>/dev/null; then
        log_success "Check requirements : npm"
    else
        log_warn "Check requirements : npm (optional, required to use LSP)"
    fi
}
# }}}

# Neovim backup and installation of Doom Nvim
# ===========================================
# {{{
backup_neovim() {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.config\/doom-nvim$ ]]; then
            log_success "Installed Doom Nvim and some demons were released, be careful!"
        else
            mv "$HOME/.config/nvim" "$HOME/.config/nvim_bak"
            log_success "Neovim backup is in $HOME/.config/nvim_bak"
            ln -s "$HOME/.config/doom-nvim" "$HOME/.config/nvim"
            log_success "Installed Doom Nvim and more demons were released!"
        fi
    else
        mkdir -p "$HOME/.config"
        ln -s "$HOME/.config/doom-nvim" "$HOME/.config/nvim"
        log_success "Installed Doom Nvim and now there are demons everywhere, be careful!"
    fi
}
# }}}

# Doom Nvim installing/updating
# =============================
# {{{
update_repo() {
    if [[ -d "$HOME/.config/doom-nvim" ]]; then
        log_info "Updating doom-nvim ..."

        cd "$HOME/.config/doom-nvim"
        git pull
        cd - >/dev/null 2>&1

        log_success "Successfully updated doom-nvim, more demons were released in your terminal!"
    else
        log_info "Trying to clone doom-nvim ..."
        git clone -q -b "$1" https://github.com/NTBBloodbath/doom-nvim "$HOME/.config/doom-nvim"
        if [ $? -eq 0 ]; then
            log_success "Successfully cloned doom-nvim, some demons were released in your terminal!"
        else
            log_error "Failed to clone doom-nvim"
            exit 0
        fi
    fi
}

install_nvim_nightly() {
    log_info "Installing Neovim Nightly AppImage ..."

    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    mkdir -p $HOME/.local/bin
    mv nvim.appimage $HOME/.local/bin/

    if [ -f "$HOME/.zshrc" ]; then
        echo "alias 'nvim'=$HOME/.local/bin/nvim.appimage" >>$HOME/.zshrc
    else
        echo "alias 'nvim'=$HOME/.local/bin/nvim.appimage" >>$HOME/.bashrc
    fi

    log_success "Successfully installed Neovim Nightly under $HOME/.local/bin/ directory"
}

install_packer() {
    if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
        log_info "Installing packer plugin manager ..."
        # NOTE: stop installing that branch when merged into the main branch
        git clone -q -b fix/premature-display-opening https://github.com/wbthomason/packer.nvim \
            $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
}

install_fonts() {
    if [[ ! -d "$HOME/.local/share/fonts" ]]; then
        mkdir -p $HOME/.local/share/fonts
    fi

    download_font "Fira Code Regular Nerd Font Complete Mono.ttf"
    log_info "Updating font cache, please wait ..."
    if [ $System == "Darwin" ]; then
        if [ ! -e "$HOME/Library/Fonts" ]; then
            mkdir "$HOME/Library/Fonts"
        fi
        cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/
    else
        fc-cache -fv >/dev/null
        mkfontdir "$HOME/.local/share/fonts" >/dev/null
        mkfontscale "$HOME/.local/share/fonts" >/dev/null
    fi
    log_success "Font cache done"
}

download_font() {
    # Download patched Nerd Fonts
    url="https://github.com/ryanoasis/nerd-fonts/raw/2.1.0/patched-fonts/FiraCode/Regular/complete/${1// /%20}"
    download_path="$HOME/.local/share/fonts/$1"
    if [[ -f "$download_path" && ! -s "$download_path" ]]; then
        rm "$download_path"
    fi

    if [[ -f "$path" ]]; then
        log_success "Downloaded $1"
    else
        log_info "Downloading $1 ..."
        curl -sLo "$download_path" "$url"
        log_success "Downloaded $1"
    fi
}

install_done() {
    echo ""
    pretty_echo ${Green} "=================================================="
    pretty_echo ${Green} "   You are almost done. Start neovim to install   "
    pretty_echo ${Green} "         the plugins and kill some demons.        "
    pretty_echo ${Green} "                                                  "
    pretty_echo ${Green} " Thanks for installing Doom Nvim, if you have any "
    pretty_echo ${Green} "             issue, please report it :)           "
    pretty_echo ${Green} "=================================================="
}
# }}}

# Uninstall Doom Nvim
# ===================
# {{{
uninstall() {
    if [[ -d "$HOME/.config/nvim" ]]; then
        if [[ "$(readlink $HOME/.config/nvim)" =~ \.config\/doom-nvim$ ]]; then
            rm "$HOME/.config/nvim"
            log_success "Uninstalled Doom Nvim"
            if [[ -d "$HOME/.config/nvim_bak" ]]; then
                mv "$HOME/.config/nvim_bak" "$HOME/.config/nvim"
                log_success "Recovered $HOME/.config/nvim_bak backup"
            fi
        fi
    fi

    if [[ -d "$HOME/.config/doom-nvim" ]]; then
        rm -rf "$HOME/.config/doom-nvim"
        log_success "Completely uninstalled Doom Nvim and the demons have been disapeared"
    fi
}
# }}}

# Init banner
# ===========
# {{{
welcome() {
    pretty_echo ${BRed} "  =================     ===============     ===============   ========  ========"
    pretty_echo ${BRed} "  \\\\\ . . . . . . .\\\\\   //. . . . . . .\\\\\   //. . . . . . .\\\\\  \\\\\. . .\\\\\// . . //"
    pretty_echo ${BRed} "  ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||"
    pretty_echo ${BRed} "  || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||"
    pretty_echo ${BRed} "  ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||"
    pretty_echo ${BRed} "  || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||"
    pretty_echo ${BYellow} "  ||. . ||   ||-'  || ||  \`-||   || . .|| ||. . ||   ||-'  || ||  \`|\_ . .|. .||"
    pretty_echo ${BYellow} "  || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ \`-_/| . ||"
    pretty_echo ${BYellow} "  ||_-' ||  .|/    || ||    \|.  || \`-_|| ||_-' ||  .|/    || ||   | \  / |-_.||"
    pretty_echo ${BYellow} "  ||    ||_-'      || ||      \`-_||    || ||    ||_-'      || ||   | \  / |  \`||"
    pretty_echo ${BYellow} "  ||    \`'         || ||         \`'    || ||    \`'         || ||   | \  / |   ||"
    pretty_echo ${BYellow} "  ||            .===' \`===.         .==='.\`===.         .===' /==. |  \/  |   ||"
    pretty_echo ${BYellow} "  ||         .=='   \_|-_ \`===. .==='   _|_   \`===. .===' _-|/   \`==  \/  |   ||"
    pretty_echo ${BYellow} "  ||      .=='    _-'    \`-_  \`='    _-'   \`-_    \`='  _-'   \`-_  /|  \/  |   ||"
    pretty_echo ${BYellow} "  ||   .=='    _-'          '-__\._-'         '-_./__-'         \`' |. /|  |   ||"
    pretty_echo ${BYellow} "  ||.=='    _-'                                                     \`' |  /==.||"
    pretty_echo ${BRed} "  =='    _-'                                                            \/   \`=="
    pretty_echo ${BRed} "  \   _-'                           N e o v i m                         \`-_    /"
    pretty_echo ${BRed} "   \`''                                                                      \`\`' "
    pretty_echo ${BYellow} "                   Version : ${DoomNvimVersion}               By : NTBBloodbath "
    echo ""
}
# }}}

# Helper and execution
# ====================
# {{{
helper() {
    welcome
    echo ""
    pretty_echo ${BRed} "  Usage ./install.sh [OPTION]"
    echo ""
    pretty_echo ${BRed} "  OPTIONS:"
    pretty_echo ${Yellow} "    -h --help                                    Displays this message"
    pretty_echo ${Yellow} "    -c --check-requirements                      Check Doom Nvim requirements"
    pretty_echo ${Yellow} "    -i --install                                 Install Doom Nvim"
    pretty_echo ${Yellow} "    -d --install-dev                             Install Development version of Doom Nvim"
    pretty_echo ${Yellow} "    -n --nightly                                 Install Neovim Nightly and Doom Nvim"
    pretty_echo ${Yellow} "    -u --update                                  Update Doom Nvim"
    pretty_echo ${Yellow} "    -v --version                                 Echo Doom Nvim version"
    pretty_echo ${Yellow} "    -x --uninstall                               Uninstall Doom Nvim"
}

main() {
    if [ $# -gt 0 ]; then
        case $1 in
        --check-requirements | -c)
            welcome
            check_requirements
            exit 0
            ;;
        --update | -u)
            welcome
            update_repo
            exit 0
            ;;
        --install | -i)
            welcome
            check_all
            update_repo "main"
            install_packer
            install_fonts
            backup_neovim
            install_done
            exit 0
            ;;
        --install-dev | -d)
            welcome
            check_all
            update_repo "develop"
            install_packer
            install_fonts
            backup_neovim
            install_done
            exit 0
            ;;
        --nvim-nightly | -n)
            welcome
            check_all
            update_repo "main"
            install_packer
            backup_neovim
            install_nvim_nightly
            install_done
            exit 0
            ;;
        --help | -h)
            helper
            exit 0
            ;;
        --version | -v)
            log "Doom Nvim v${DoomNvimVersion}"
            exit 0
            ;;
        --uninstall | -x)
            welcome
            log_info "Uninstalling Doom Nvim ..."
            uninstall
            pretty_echo ${Green} "Thanks for using Doom Nvim, there are no more demons!"
            exit 0
            ;;
        esac
    else
        # Run normal commands
        welcome
        check_all
        update_repo "main"
        install_packer
        backup_neovim
        install_fonts
        check_requirements
        install_done
    fi
}

main $@
# }}}
