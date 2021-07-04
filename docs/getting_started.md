# Getting Started

## Table of Contents

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
    - [Using cheovim](#using-cheovim)
- [Update & Rollback](#update--rollback)
  - [Update Doom Nvim](#update-doom-nvim)
  - [Rollback](#rollback)
- [Configuration](#configuration)
  - [Modules](#modules)
  - [Plugins Management](#plugins-management)
    - [Installing plugins](#installing-plugins)
    - [Disabling plugins](#disabling-plugins)
  - [Configuring Doom](#configuring-doom)
    - [Configuring settings](#configuring-settings)
    - [Configuring plugins](#configuring-plugins)
    - [Configuring LSP](#configuring-lsp)
  - [Binding keys](#binding-keys)
- [Migrating to 3.0.0](#migrating-to-300)

## Install

This is what you will have installed by the end of this section:

- Git 2.23+
- Neovim 0.5.0 (Neovim 0.4 not supported, see [faq](https://github.com/NTBBloodbath/doom-nvim/blob/main/docs/faq.md#why-does-doom-nvim-only-support-neovim-nightly) to know why)
- ripgrep 11.0+
- GNU Find
- (Optional) fd 7.3.0+ (known as `fd-find` on Debian, Ubuntu & derivates),
  improves performance for many file indexing commands
- (Optional) node & npm, required to use LanguageServerProtocols (LSP) and the plugins using LSP, like the symbols-outline plugin.

These packages ought to be available through the package managers of your OS;
i.e. pacman/aptitude/rpm/etc on the various Linux distributions.

### Neovim & dependencies

#### On Linux

Since Neovim 0.5 is a night version, it does not come packaged in the repositories
of your distribution, so you have several options to install it.

1. Using the Doom Nvim install script to download a Neovim Nightly AppImage from releases
   (see how by executing the installer with <kbd>bash -s -- -h</kbd>).

2. Using extra repositories according to your distribution (PPA/COPR/AUR/etc).

3. Using a Neovim version manager like [nvenv](https://github.com/NTBBloodbath/nvenv).

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

You can download a prebuilt binary from the [Neovim](https://github.com/neovim/neovim/releases/tag/nightly) nightly releases page.

1. Download: `curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz`
2. Extract: `tar xzvf nvim-macos.tar.gz`
3. Run: `./nvim-osx64/bin/nvim`

You may wish to add it to your PATH using something like:
`export PATH="$HOME/nvim-osx64/bin:$PATH"`

Neovim nightly can also be downloaded with [homebrew](https://brew.sh/):

`brew install --HEAD neovim` will download the source and build it locally on your machine.

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

#### On Windows

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

You can also download a prebuilt binary from the [Neovim](https://github.com/neovim/neovim/releases) releases page.

### External dependencies

#### On Linux

##### Ubuntu

```sh
# Required dependencies
apt-get install git ripgrep

# (Optional) Improves performance for many file indexing commands
apt-get install fd-find

# (Optional) Required by Language Server Protocols
apt-get install nodejs npm
```

##### Fedora

```sh
# Required dependencies
dnf install git ripgrep

# (Optional) Improves performance for many file indexing commands
dnf install fd-find # is 'fd' in Fedora <28

# (Optional) Required by Language Server Protocols
dnf install nodejs
```

##### Arch

```sh
# Required dependencies
pacman -S git ripgrep

# (Optional) Improves performance for many file indexing commands
pacman -S fd

# (Optional) Required by Language Server Protocols
pacman -S nodejs npm
```

#### On MacOS

If you use MacOS, please help by posting the steps to install the external
dependencies here!

#### On Windows

If you use Windows, please help by posting the steps to install the external
dependencies here!

### Doom Nvim

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

#### Using cheovim

If you're using cheovim as your Neovim configurations manager you can use the
recipe listed in cheovim documentation:

```lua
doom_nvim = { "~/.config/doom-nvim", {
        plugins = "packer",
        preconfigure = "doom-nvim"
    }
}
```

## Update & Rollback

### Update Doom Nvim

To update Doom Nvim, you have two options, run `:DoomUpdate` inside Neovim or
run the installation script with <kbd>bash -s -- -u</kbd>.

### Rollback

To uninstall Doom Nvim and go back to your previous setup, simply run the
installation script with <kbd>bash -s -- -x</kbd>. It will uninstall Doom Nvim
and restore the backup of your previous setup.

## Configuration

You can configure Doom Nvim by tweaking the file `doomrc` in your Doom Nvim root
dir (`$HOME/.config/doom-nvim/` by default), please see
<kbd>:h doom_nvim_options</kbd> for more information.

> **IMPORTANT:** any changes to your Doom Nvim configuration occassionally
> need a run of `:PackerSync` inside Neovim (if you're using the stable branch).
> For instance, when you enable a disabled plugin.

### Modules

Doom Nvim consists of around 7 modules and growing. A Doom Nvim Module is a bundle of plugins,
configuration and commands, organized into a unit that can be toggled easily by
tweaking your doomrc (found in `$HOME/.config/doom-nvim`).

Please see [Plugins Management](#plugins-management) for more information.

> **IMPORTANT:** any changes to your Doom Nvim Modules won't take effect until
> you run `:PackerSync` inside Neovim.

### Plugins Management

Doom Nvim uses a declarative and use-package inspired package manager called
[packer.nvim](https://github.com/wbthomason/packer.nvim).

Modules and plugins are declared in `lua/doom/modules/init.lua` file, located
in your Doom Nvim root dir. Read on to learn how to use this system to install
your own plugins.

> **WARNING:** Do not install plugins directly in `lua/doom/modules/init.lua`. Instead,
> use your `doomrc` to modify them.

#### Installing plugins

To install a custom plugin, add it to `custom_plugins` field into the `Doom` table
in your `doomrc`.

```lua
-- @default = {}
custom_plugins = { 'plugin_author/plugin_repo' }
```

You can also use other method if the plugin depends on other plugins. All the
available options for the plugins can be found on
[packer.nvim](https://github.com/wbthomason/packer.nvim) README file.

```lua
custom_plugins = {
    'plugin_author/plugin_repo',
    {
        'plugin_author/second_plugin_repo',
        disable = false, -- not required, false by default
        requires = { 'foo', 'bar' } -- not required if the plugin does not have dependencies
    },
}
```

> **NOTES:**
>
> 1. Do not forget to run `:PackerInstall` to install your new plugins if you're
>    using the stable branch of Doom Nvim.

#### Disabling plugins

To disable plugins from Doom Nvim Modules or disable a module itself, just use the
`disabled_plugins` and/or `disabled_modules` fields.

```lua
-- @default = {}
disabled_plugins = { 'terminal', 'treesitter' }

-- @default = { 'git', 'lsp', 'web' }
disabled_modules = { 'web' }
```

> **NOTES:**
>
> 1. Do not forget to run `:PackerSync` or your changes won't take effect if you're
>    using the stable branch of Doom Nvim.
>
> 2. You can see a list of the plugins that you can disable on [Modules](./modules.md#list-of-modules).
>
> 3. You can also see how to enable/disable plugins modules on [Modules](./modules.md).

### Configuring Doom

#### Configuring settings

You can change Doom's default settings by tweaking your `doomrc`, please see
<kbd>:h doom_nvim_options</kbd> to know how to.

#### Configuring plugins

Do you want to change some configurations of some modules?

Go to `lua/doom/modules/config` dir and you will find the configurations for the plugins.

##### Configuring LSP

[LSP](https://microsoft.github.io/language-server-protocol/) is installed as a plugin.
Be aware that this plugin is disabled per default. To enable it, remove it from the
`disabled_modules` section in your `doomrc`.

To easily install LSPs and without having to do it system-wide or having to
manually configure servers, Doom Nvim makes use of [kabouzeid/nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall).

You can see a list of currently supported languages at [bundled installers](https://github.com/kabouzeid/nvim-lspinstall#bundled-installers).

> Usage example:

- `:LspInstall python` to install Python LSP
- `:LspUninstall python` to uninstall Python LSP

### Binding keys

You can modify the default keybindings by modifying the following files:

- `lua/doom/core/keybindings/init.lua` - General and SPC keybindings
- `lua/doom/modules/config` - lua plugins keybindings

You can also define your own keybindings in your `doomrc` with the `Neovim.mappings` field.

## Migrating to 3.0.0

> At the time of writing this (2021-06-30) version 3.0.0 is still in development
> and subject to breaking changes.

As this is a major version, there are many improvements and breaking changes.
This section is made to help you migrate to this version without dying in the
attempt.

But first let's see what's new:

### Changes for end users

- Raw speed, never go slow again.
  Reduced average startuptime from 400ms to 40ms, special thanks to [vhyrro]
- New and better doom-one colorscheme written in pure Lua. Because the
  colorscheme matters.
- Easily add new Neovim settings by using your `doomrc`. Extensibility is a
  feature that you cannot miss, and what better than being able to extend as
  much as you want?
- New logging system powered by [vlog]. A faster and smaller logging system
  because complexity is not always the best choice.
- Better custom plugins handler. Now the custom plugins are being directly
  handled by packer as it should be, no more non-sense wrappers around it.
- Built-in plugins. Because we should have some utilities to make our lifes
  easier, isn't this how it should be? See [modules/doom] for more information
  (WIP).
- Fragmented configuration file (`doomrc`) so it will be more easy to customize
  Doom nvim (**breaking change**).
- A lot of bug fixes.

### Changes for contributors

- Better documentation. Added docs for each doom lua module because
  documentation is the core of all projects.
- Restructured source code. Now the doom nvim source code is more cleaner and
  easier to understand.
- Added selene linter CI for incoming pull requests and stylua CI for pushs.
  Let's get a consistent way to maintain doom nvim source.

> **IMPORTANT:** This what's new section is subject to changes while version
> 3.0.0 is in development. Changes are expected.
>
> You can also see the [Version 3.0.0 roadmap](https://github.com/NTBBloodbath/doom-nvim/projects/5)
> for seeing the current progress.

Now that we know what's new we will surely want to update, isn't it?

Due to the new raw speed we highly recommend to do a fresh installation so
everything will be work as intended. **Make sure to backup your doomrc changes**.

We don't recommend using the `:DoomUpdate` command for this task because of the
huge changes that doom nvim suffered. This command will only end in a really
bad status for this release due to git merging issues.

Said that, you can run the following command snippet.

> **IMPORTANT:**
>
> 1. Make sure to read everything it does before executing it.
>
> 2. If you are using cheovim just remove and clone the doom-nvim repository again.

```sh
cp $HOME/.config/doom-nvim/doomrc $HOME/.config/doomrc.bak \
    && rm -rf $HOME/.config/doom-nvim $HOME/.local/share/nvim/site/pack/packer \
    && unlink $HOME/.config/nvim \
    && curl -sLf https://raw.githubusercontent.com/NTBBloodbath/doom-nvim/main/install.sh | bash -s -- -d
```

This snippet will do the following tasks for you:

1. Create a copy of your doomrc so you can use a diff tool later with the
   actual breaking changes to doomrc structure.
2. Remove the doom-nvim configuration directory and all plugins (including packer).
3. Remove the residual symlink that doom-nvim have created before during the
   installation (**omit that step if you're using cheovim**).
4. Clone doom-nvim source to where it belongs again by using the installer
   (installing the development branch because this version is not released yet).

Then you'll only need to start Neovim and start using it as usual!

#### New configurations

Since version 3.0.0 the doomrc has been fragmented into some files, but why?

This was done to benefit both contributors and end users as follows:

- Improve understanding. One file that handles everything doesn't seem like a
  good thing on a large scale.
- Easier to maintain. Divided by function, the new files make the code more
  readable and easy to modify.

And now, how can I start using the new configuration files?

I'm going to explain you in a short way because the new configuration files has
a rich documentation inside them.

- `doomrc.lua`, this file handles the doom nvim modules, in other words, which
  plugins are being installed and loaded and which plugins are not.
- `doom_config.lua`, this file handles the user configurations for doom nvim,
  e.g. if mouse is enabled or not. This one also handles user-defined Neovim
  configurations like global variables.
- `plugins.lua`, this file handles the user-defined plugins, it is the
  replacement for the `custom_plugins` field in the old doomrc.

> Are you having issues with the development version? Don't hesitate to [report them]
> so we can fix them and make doom more stable because that's the way to improve software.

[vlog]: https://github.com/tjdevries/vlog.nvim
[vhyrro]: https://github.com/vhyrro
[modules/doom]: https://github.com/NTBBloodbath/doom-nvim/tree/develop/lua/doom/modules/doom
[report them]: https://github.com/NTBBloodbath/doom-nvim/issues/new
