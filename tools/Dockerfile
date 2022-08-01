FROM	 archlinux:latest 

LABEL \
        maintainer="n.debonnaire@gmail.com" \
        url.github="https://github.com/nicodebo/neovim-docker" \
        url.dockerhub="https://hub.docker.com/r/nicodebo/neovim-docker/"

ENV \
  UID="1000" \
  GID="1000" \
  UNAME="doom" \
  GNAME="doom" \
  SHELL="/bin/bash" \
  WORKSPACE="" \
	NVIM_CONFIG="/home/doom/.config/nvim" \
	PATH="/home/doom/.local/bin:${PATH}"

# Update repositories
RUN	pacman -Syy

# Install neovim
RUN pacman -Sy neovim --noconfirm

# Install runtime dependencies of doom-nvim
RUN pacman -Sy ripgrep nodejs-lts-fermium npm git bash gcc jq --noconfirm

# Lua
RUN pacman -Sy luacheck stylua --noconfirm

# Required for nvim-lsp-installer
RUN pacman -Sy wget unzip make --noconfirm

# Required for watching Doom-nvim-contrib for changes
RUN npm i -g chokidar-cli

# Required for OCaml language
# RUN pacman -Sy opam diffutils patch ocaml --noconfirm

# Create the doom user and group
RUN groupadd doom
RUN useradd -m -g doom doom

RUN mkdir /usr/local/lib/node_modules
RUN chown -R ${UNAME}:${GNAME} /usr/local/lib/node_modules/

USER doom
WORKDIR /home/doom

# Required for OCaml language
# RUN opam init --disable-sandboxing && opam install ocaml-lsp-server -y

COPY _docker_entry.sh /usr/local/bin/

# Doom-nvim-contrib
VOLUME "~/.config/nvim"
# For storing packer plugins
VOLUME "~/.local/share/nvim"
# Files and projects for testing on disk
VOLUME "~/workspace"

ENTRYPOINT ["sh", "/usr/local/bin/_docker_entry.sh"]
