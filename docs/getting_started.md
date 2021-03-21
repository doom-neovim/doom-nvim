# Getting Started

# Table of Contents
- [Install](#install)
  - [Neovim & dependencies](#neovim--dependencies)
    - [On Linux](#on-linux)
      - [Ubuntu](#ubuntu)
      - [Fedora](#fedora)
      - [Arch Linux](#arch)
    - [On MacOS](#on-macos)
    - [On Windows](#on-windows)
  - [External dependencies](#external-dependencies)
    - [On Linux](#on-linux)
      - [Ubuntu](#ubuntu)
      - [Fedora](#fedora)
      - [Arch Linux](#arch)
    - [On MacOS](#on-macos)
    - [On Windows](#on-windows)
  - [Doom Nvim](#doom-nvim)
- [Update & Rollback](#update--rollback)
  - [Update Doom Nvim](#update-doom-nvim)
  - [Rollback](#rollback)
- [Configuration](#configuration)
  - [Modules](#modules)
  - [Package Management](#package-management)
    - [Installing plugins](#installing-plugins)
    - [Disabling plugins](#disabling-plugins)
  - [Configuring Doom](#configuring-doom)
    - [Configuring settings](#configuring-settings)
    - [Configuring plugins](#configuring-plugins)
  - [Binding keys](#binding-keys)

# Install

This is what you will have installed by the end of this section:

- Git 2.23+
- Neovim 0.5.0 (Neovim 0.4 currently not supported, see [projects](https://github.com/NTBBloodbath/doom-nvim/projects))
- Lua 5.1+
- ripgrep 11.0+
- GNU Find
- (Optional) fd 7.3.0+ (known as `fd-find` on Debian, Ubuntu & derivates),
  improves performance for many file indexing commands
- (Optional) node & npm, required to use LanguageServerProtocols (LSP).

These packages ought to be available through the package managers of your OS;
i.e. pacman/aptitude/rpm/etc on the various Linux distributions.

## Neovim & dependencies

### On Linux

Since Neovim 0.5 is a night version, it does not come packaged in the repositories
of your distribution, so you have several options to install it.

1. Using the Doom Nvim install script to download a Neovim Nightly AppImage from releases
   (see how by executing the installer with <kbd>bash -s -- -h</kbd>).

2. Using extra repositories according to your distribution (PPA/COPR/AUR/etc).

#### Ubuntu

You can get nightly builds of git master from the
[Neovim Unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable).

```sh
add-apt-repository ppa:neovim-ppa/unstable
apt-get update
```

#### Fedora

You can get nightly builds of git master from the
[Agriffis's Copr](https://copr.fedoraproject.org/coprs/agriffis/neovim-nightly/).

```sh
dnf copr enable agriffis/neovim-nightly
dnf install -y neovim python{2,3}-neovim
```

#### Arch

Neovim Nightly builds can be installed using the PKGBUILD
[`neovim-nightly-bin`](https://aur.archlinux.org/packages/neovim-nightly-bin),
available on the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository).

### On MacOS

If you use MacOS, please help by posting the steps to install Neovim Nightly here!

### On Windows

If you use Windows, please put the steps to install Neovim Nightly here!

## External dependencies

### On Linux

#### Ubuntu

```sh
# Required dependencies
apt-get install git lua ripgrep
# (Optional) Improves performance for many file indexing commands
apt-get install fd-find
# (Optional) Required by LanguageServerProtocols
apt-get install nodejs npm
```

#### Fedora

```sh
# Required dependencies
dnf install git lua ripgrep
# (Optional) Improves performance for many file indexing commands
apt-get install fd-find # is 'fd' in Fedora <28
# (Optional) Required by LanguageServerProtocols
dnf install nodejs
```

#### Arch

```sh
# Required dependencies
pacman -S git lua ripgrep
# (Optional) Improves performance for many file indexing commands
pacman -S fd
# (Optional) Required by LanguageServerProtocols
pacman -S nodejs npm
```

### On MacOS

If you use MacOS, please help by posting the steps to install the external
dependencies here!

### On Windows

If you use Windows, please help by posting the steps to install the external
dependencies here!

## Doom Nvim

With Neovim Nightly and Doom's dependencies installed, next is to install
Doom Nvim itself:

> **NOTES:**
1. If you have not installed Neovim Nightly yet, please run the following command
   before installing Doom Nvim, it will install Neovim nightly and Doom Nvim.
2. If you want to know all the commands of the installer, run the installer with
   <kbd>bash -s -- -h</kbd> instead of just <kbd>bash</kbd>.

```sh
# Check if you have all the dependencies listed above
curl -sLf https://raw.githubusercontent.com/NTBBloodbath/doom-nvim/main/install.sh | bash -s -- -c
```

```sh
# If you do not have Neovim nightly but you have all the dependencies listed above
curl -sLf https://raw.githubusercontent.com/NTBBloodbath/doom-nvim/main/install.sh | bash -s -- -n
```

```sh
# If you already have Neovim nightly and all the dependencies listed above
curl -sLf https://raw.githubusercontent.com/NTBBloodbath/doom-nvim/main/install.sh | bash
```

The installation script will set up everything for you and will work you through
the first-time setup of Doom Nvim.

# Update & Rollback

## Update Doom Nvim

To update Doom Nvim, you have two options, run `:DoomUpdate` inside Neovim or
run the installation script with <kbd>bash -s -- -u</kbd>.

## Rollback

To uninstall Doom Nvim and go back to your previous setup, simply run the
installation script with <kbd>bash -s -- -x</kbd>. It will uninstall Doom Nvim
and restore the backup of your previous setup.

# Configuration

You can configure Doom Nvim by tweaking the file `doomrc` in your Doom Nvim root
dir (`$HOME/.config/doom-nvim/` by default), please see
<kbd>:h doom_nvim</kbd> for more information.

## Modules

Doom Nvim consists of around 7 modules and growing. A Doom Nvim Module is a bundle of plugins,
configuration and commands, organized into a unit that can be toggled easily by
tweaking your doomrc (found in `$HOME/.config/doom-nvim`).

Please see [Package Management](#package-management) for more information.

> **IMPORTANT:** any changes to your Doom Nvim Modules won't take effect until
> you run `:PackerSync` inside Neovim.

## Package Management

Doom Nvim does not use Vim-Plug in the Neovim Nightly version. Instead, it uses
a declarative and use-package inspired package manager called
[packer.nvim](https://github.com/wbthomason/packer.nvim).

Modules and plugins are declared in `lua/plugins.lua` file, located in your doom nvim root dir.
Read on to learn how to use this system to install your own plugins.

> **WARNING:** Do not install plugins directly in `lua/plugins.lua`. Instead,
> use your `doomrc` to modify them.

### Installing plugins

To install a custom package, add it to `g:doom_custom_plugins` variable into your
`doomrc`.

```vim
" @default = []
let g:doom_custom_plugins = ['plugin_author/plugin_repo']
```

> **NOTES:**
> 1. Do not forget to run `:PackerInstall` to install your new plugins.

### Disabling plugins

To disable plugins from Doom Nvim Modules or disable a module itself, just use the
`g:doom_disabled_plugins` and/or `g:doom_disabled_modules`.

```vim
" @default = []
let g:doom_disabled_plugins = ['terminal', 'treesitter']

" @default = ['git', 'lsp', 'web']
let g:doom_disabled_modules = ['web']
```

> **NOTES:**
> 1. Do not forget to run `:PackerSync` or your changes won't take effect.
>
> 2. You can see a list of the plugins that you can disable on [Modules](./modules.md#list-of-modules).

## Configuring Doom

### Configuring settings

You can change Doom's default settings by tweaking your `doomrc`, please see
<kbd>:h doom_nvim</kbd> to know how to.

### Configuring plugins

Do you want to change some configurations of some modules?

Go to `lua/configs` dir and you will find the configurations for the Lua plugins,
or go to `config/plugins` dir to change the Vimscript plugins configurations.

### Binding keys

You can set your own keybindings by modifying the `config/keybindings.vim`,
`config/plugins/leader-mapper.vim` and `lua/configs` files.
