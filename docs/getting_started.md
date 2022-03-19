# Getting Started

## Install

This is what you will have installed by the end of this section:

- Git
- Neovim 0.6.0+
- GNU Find
- **Optional**: ripgrep 11.0+ (highly recommended)
- **Optional**: fd 7.3.0+ (known as `fd-find` on Debian, Ubuntu & derivates),
  improves performance for many file indexing commands
- **Optional**: node & npm, required to use some Language Server Protocols (LSP) and packages using LSP, like the symbols-outline plugin.

These packages should to be available through the package managers of your OS;
i.e. pacman/aptitude/rpm/etc on the various Linux distributions.

### Neovim & dependencies

#### On Linux

Neovim 0.5.0 was recently released as a stable version.
You can check what version your repository has by looking at [this site.](https://repology.org/project/neovim/versions)
If Neovim 0.5.0 is still not available in your repository, you can install it by doing one of the following:

1. Using extra repositories according to your distribution (PPA/COPR/AUR/etc).

2. Using a Neovim version manager like [nvenv](https://github.com/NTBBloodbath/nvenv).

##### Ubuntu

You can get nightly builds of git master from the
[Neovim Unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable).

```sh
add-apt-repository ppa:neovim-ppa/unstable
apt-get update
```

##### Fedora

Nightly builds can be installed by using the
[agriffis/neovim-nightly](https://copr.fedorainfracloud.org/coprs/agriffis/neovim-nightly/)
COPR repository.

```sh
dnf copr enable agriffis/neovim-nightly
dnf update
```

##### Arch

Neovim Nightly builds can be installed using the PKGBUILD
[`neovim-nightly-bin`](https://aur.archlinux.org/packages/neovim-nightly-bin),
available on the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository).

#### On MacOS

You can download a prebuilt binary from the [Neovim](https://github.com/neovim/neovim/releases/tag/nightly) releases page.

1. Download: `curl -LO https://github.com/neovim/neovim/releases/download/v0.5.0/nvim-macos.tar.gz`
2. Extract: `tar xzvf nvim-macos.tar.gz`
3. Run: `./nvim-osx64/bin/nvim`

You may wish to add it to your PATH using something like:
`export PATH="$HOME/nvim-osx64/bin:$PATH"`

Neovim nightly can also be downloaded with [homebrew](https://brew.sh/):

`brew install --HEAD neovim` will download the source and build it locally on your machine.

If you already have Neovim v0.4 installed you may need to unlink it.

```
brew unlink neovim
brew install neovim --HEAD
nvim --version
```

MacPorts currently only has Neovim v0.4.4

#### On Windows

> **NOTE**: new module architecture is pending tests on Windows.

##### [Chocolatey](https://community.chocolatey.org/)

```
choco install neovim --pre
```

##### [Scoop](https://scoop.sh/)

```
scoop bucket add versions
scoop install neovim-nightly
```

##### Manual

1. Download a prebuilt binary from the [Neovim](https://github.com/neovim/neovim/releases) releases page.
2. Unpack the binary
3. Move and symlink to somewhere in your path

```sh
# unpack the binary
tar xzvf nvim-linux64.tar.gz

# create a directory to store the unpacked folder
sudo mkdir /opt/nvim

# move the unpacked binary
sudo mv nvim-linux64 /opt/nvim

# add the neovim executable to somewhere in your path
# ex: /usr/bin OR $HOME/.local/bin
sudo ln -s /opt/nvim/nvim-linux64/bin/nvim /usr/bin/nvim

# should print /usr/bin/nvim
which nvim

# should print NVIM 0.5
nvim --version
```

```
# unpack the binary
tar xzvf nvim-linux64.tar.gz

# create a directory to store the unpacked folder
sudo mkdir /opt/nvim

# move the unpacked binary
sudo mv nvim-linux64 /opt/nvim

# add the neovim executable to somewhere in your path
# ex: /usr/bin OR $HOME/.local/bin
sudo ln -s /opt/nvim/nvim-linux64/bin/nvim /usr/bin/nvim

# should print /usr/bin/nvim
which nvim

# should print NVIM 0.5
nvim --version
```
### External dependencies

#### On Linux

##### Ubuntu

```sh
# Required dependencies
apt-get install git ripgrep

# (Optional) Improves performance for many file indexing commands
apt-get install fd-find

# (Optional) Required by some Language Server Protocols
apt-get install nodejs npm
```

##### Fedora

```sh
# Required dependencies
dnf install git ripgrep

# (Optional) Improves performance for many file indexing commands
dnf install fd-find # is 'fd' in Fedora <28

# (Optional) Required by some Language Server Protocols
dnf install nodejs
```

##### Arch

```sh
# Required dependencies
pacman -S git ripgrep

# (Optional) Improves performance for many file indexing commands
pacman -S fd

# (Optional) Required by some Language Server Protocols
pacman -S nodejs npm
```

#### On MacOS

Dependencies can be installed using [homebrew](https://brew.sh/)

```sh
# Required dependencies
# git is already installed as part of MacOS
brew install ripgrep ctags

# (Optional) Required by Language Server Protocols
brew install node
```

#### On Windows

If you use Windows, please help by posting the steps to install the external
dependencies here!

### Doom Nvim

With Neovim v0.5.0 and Doom's dependencies installed, next is to install
Doom Nvim itself.

> **IMPORTANT**: if you don't have a patched nerd font then you will need to
> install one in your system so you will be able to see icons in Neovim.

First you'll want to backup your current Neovim configuration if you have one.

> **NOTES**:
>
> 1. Your current configuration will be backed up to `~/.config/nvim.bak`
>    or where your `XDG_CONFIG_HOME` environment variable points to.
>
> 2. If you're a cheovim user you can skip this step and go directly to
>    [Using cheovim](#using-cheovim).

```sh
[ -d ${XDG_CONFIG_HOME:-$HOME/.config}/nvim ] && mv ${XDG_CONFIG_HOME:-$HOME/.config}/nvim ${XDG_CONFIG_HOME:-$HOME/.config}/nvim.bak
```

Now that you have backed up your current Neovim configuration you can proceed to install
`doom-nvim`.

```sh
git clone --depth 1 https://github.com/NTBBloodbath/doom-nvim.git ${XDG_CONFIG_HOME:-$HOME/.config}/nvim
```

Or if you want to live in the bleeding-edge with the latest features:

```sh
git clone --depth 1 -b develop https://github.com/NTBBloodbath/doom-nvim.git ${XDG_CONFIG_HOME:-$HOME/.config}/nvim
```

## Update & Rollback

### Update Doom Nvim

To update Doom Nvim, you have two options, run `:DoomUpdate` or <kbd>SPC d u</kbd>
inside Neovim or alternatively run `git pull` in doom-nvim directory (**not recommended, see why below**).

#### Why use the built-in doom command for updating instead of running git pull manually?

> **TODO**: These commands are pending testing in the new module architecture.

> **tl;dr**: The `:DoomUpdate` command creates an additional local database of the doom-nvim
> releases so in case something breaks you can easily rollback to a previous doom-nvim version

The reason is that `doom-nvim` also brings a functionality for rolling back to a previous version
or a previous state (e.g. a previous commit) and doing it manually can be a bit tedious (looking
for the previous release tag or the previous commit hash if there were too much commits).
Our `:DoomUpdate` command creates a local database into the `doom-nvim` directory depending on
what branch are you using because if you are using the development branch you will not want to
rollback to a previous version, isn't it?

So, if you are using the main a.k.a stable branch of doom-nvim, the `:DoomUpdate` command will
create a local database of doom-nvim's releases. Otherwise, if you're using the development branch
it will create a local file with the commit hash that you were using before updating.

### Rollback

#### Previous Configurations

To uninstall Doom Nvim and go back to your previous setup, simply remove the `~/.config/nvim`
directory if it's where you have `doom-nvim` installed and move your backup.

```sh
rm -rf ${XDG_CONFIG_HOME:-$HOME/.config}/nvim \
    && mv ${XDG_CONFIG_HOME:-$HOME/.config}/nvim.bak ${XDG_CONFIG_HOME:-$HOME/.config}/nvim
```

#### Rolling Back Doom

Did the update screw up your setup because of a bug or a breaking change and you want to rollback?
Then you're lucky. Just run `:DoomRollback` in Neovim and Doom will rollback itself to
a previous release (for main branch) or a previous commit (for development branch).

> **IMPORTANT**: remember to report the issues before just rolling back. In that
> way we can work on fixing them and make doom better!

## Configuration

You can configure Doom Nvim by tweaking the `config.lua` and
`modules.lua` files located in your Doom Nvim root directory
(`$HOME/.config/doom-nvim/` by default).

### modules.lua

This file handles all the Doom Nvim modules, copy the one in the root of this
repo for a template.

> **NOTE**: for more information please refer to [modules].

### config.lua

This file handles all the Doom Nvim configurations, including the ability to easily
create new custom mappings and global Neovim variables.

It has no proper structure, but revolves around the `doom` global variable.
See each module's documentation for options.

> **NOTE**: all your used-defined configurations here will be live-reloaded, e.g.
> mappings, autocommands, etc.

### Plugin Management

Doom Nvim uses a declarative and use-package inspired package manager called
[packer.nvim](https://github.com/wbthomason/packer.nvim).

Each Doom module has a folder inside `lua/doom/modules/`, with the following
files:

- `init.lua`: has default options and packer `config` functions.
- `packages.lua`: has packer specs, except for the config key.
- `binds.lua` (optional): has bindings for the module.
- `autocmds.lua` (optional): has autocmds.

> **WARNING:** Do not change modules directly in Doom source code. Instead,
> use your `modules.lua` and `config.lua` files to modify them.

### Configuring Doom

#### Configuring settings

You can change Doom's default settings by tweaking your `config.lua` file,
please see [modules] to know how.

## Migrating to 4.0.0

As this is a major version, there are many improvements and breaking changes.
This section is made to help you migrate to this version without having to
respawn.

### Changes for end users

- Make modules more granular and configurable, allowing everything to be
  overriden.
- Completely change the structure of `config.lua` to revolve around a
  single settings store.
- Remove the category groupings in modules.
- Remove the need to return the filepath from each config file.
- Fully move all data file to stdpath("data").
- Fix bugs.

### Changes for contributors

- Restructured source code. The Doom Nvim source code is now cleaner and
  easier to understand. Many things have been flattened, no module is special
  anymore, some things were removed in favor of later implementations
  out-of-source.
- Adding modules is simpler, it only requires creating a new module folder
  and adding its configuration.
- Care should be taken with order of execution, since you only have config
  accesible after the doom global is created. You can't, for instance,
  use the global do define defaults in `lua/doom/core/config/init.lua`.
  This is rarely a problem, but worth mentioning.

We recomend doing a fresh install, backing up your current
`~/.config/doom-nvim` for reference. Sadly, it cannot be used as is, and there's
no migration script yet.

#### New configurations


[packer.nvim]: https://github.com/wbthomason/packer.nvim
[vhyrro]: https://github.com/vhyrro
[modules]: ./modules.md
[report them]: https://github.com/NTBBloodbath/doom-nvim/issues/new
