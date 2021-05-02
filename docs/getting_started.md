# Getting Started

# Table of Contents

- [Install](#install)
  - [Neovim & dependencies](#neovim--dependencies)
    - [On Linux](#on-linux)
      - [Ubuntu](#ubuntu)
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
    - [Configuring LSP](#configuring-lsp)
  - [Binding keys](#binding-keys)

# Install

This is what you will have installed by the end of this section:

- Git 2.23+
- Neovim 0.5.0 (Neovim 0.4 not supported, see [faq](https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/faq.md#why-does-doom-nvim-only-support-neovim-nightly) to know why)
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

#### Arch

Neovim Nightly builds can be installed using the PKGBUILD
[`neovim-nightly-bin`](https://aur.archlinux.org/packages/neovim-nightly-bin),
available on the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository).

### On MacOS

Neovim nightly can be installed with [homebrew](https://brew.sh/) with the following command.

`brew install --HEAD neovim`

If you already have Neovim v4 installed you may need to unlink it.

```
brew unlink neovim
brew install neovim --HEAD
nvim --version
```

MacPorts currently only has Neovim v4.4

You can also download a prebuilt binary from the [Neovim](https://github.com/neovim/neovim/releases) releases page.

1. Download nvim-macos.tar.gz
2. Extract: tar xzvf nvim-macos.tar.gz
3. Run ./nvim-osx64/bin/nvim

### On Windows

If you use Windows, please put the steps to install Neovim Nightly here!

## External dependencies

### On Linux

#### Ubuntu

```sh
# Required dependencies
apt-get install git ripgrep
# (Optional) Improves performance for many file indexing commands
apt-get install fd-find
# (Optional) Required by Language Server Protocols
apt-get install nodejs npm
```

#### Fedora

```sh
# Required dependencies
dnf install git ripgrep
# (Optional) Improves performance for many file indexing commands
dnf install fd-find # is 'fd' in Fedora <28
# (Optional) Required by Language Server Protocols
dnf install nodejs
```

#### Arch

```sh
# Required dependencies
pacman -S git ripgrep
# (Optional) Improves performance for many file indexing commands
pacman -S fd
# (Optional) Required by Language Server Protocols
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

Modules and plugins are declared in `lua/plugins/init.lua` file, located in your Doom Nvim root dir.
Read on to learn how to use this system to install your own plugins.

> **WARNING:** Do not install plugins directly in `lua/plugins/init.lua`. Instead,
> use your `doomrc` to modify them.

### Installing plugins

To install a custom plugin, add it to `custom_plugins` field into the `Doom` table
in your `doomrc`.

```lua
-- @default = {}
custom_plugins = { 'plugin_author/plugin_repo' }
```

You can also use other method if the plugin depends on other plugins.

```lua
custom_plugins = {
    'plugin_author/plugin_repo',
    {
        'repo': 'plugin_author/second_plugin_repo',
        'enabled': true, -- not required, true by default
        'requires': { 'foo', 'bar' } -- not required if the plugin does not have dependencies
    },
}
```

> **NOTES:**
>
> 1. Do not forget to run `:PackerInstall` to install your new plugins.

### Disabling plugins

To disable plugins from Doom Nvim Modules or disable a module itself, just use the
`disabled_plugins` and/or `disabled_modules` fields.

```lua
-- @default = {}
disabled_plugins = { 'terminal', 'treesitter' }

-- @default = { 'git', 'lsp', 'web' }
let g:doom_disabled_modules = { 'web' }
```

> **NOTES:**
>
> 1. Do not forget to run `:PackerSync` or your changes won't take effect.
>
> 2. You can see a list of the plugins that you can disable on [Modules](./modules.md#list-of-modules).
>
> 3. You can also see how to enable/disable plugins modules on [Modules](./modules.md).

## Configuring Doom

### Configuring settings

You can change Doom's default settings by tweaking your `doomrc`, please see
<kbd>:h doom_nvim</kbd> to know how to.

### Configuring plugins

Do you want to change some configurations of some modules?

Go to `lua/plugins/configs` dir and you will find the configurations for the plugins.

### Configuring LSP

To easily install LSPs and without having to do it system-wide or having to
manually configure servers, Doom Nvim makes use of [kabouzeid/nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall).
You can see a list of currently supported languages at [bundled installers](https://github.com/kabouzeid/nvim-lspinstall#bundled-installers).

> Usage example:

- `:LspInstall python` to install Python LSP
- `:LspUninstall python` to uninstall Python LSP

## Binding keys

You can modify the default keybindings by modifying the following files:

- `lua/doom/keybindings/init.lua` - General and SPC keybindings
- `lua/plugins/configs` - lua plugins keybindings
