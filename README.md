<div align="center">

# Doom Neovim

![License](https://img.shields.io/github/license/NTBBloodbath/doom-nvim?style=flat-square)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![Latest Release](https://img.shields.io/github/v/release/NTBBloodbath/doom-nvim?include_prereleases&style=flat-square)
![Neovim version](https://img.shields.io/badge/Neovim-0.5-57A143?style=flat-square&logo=neovim)

[Features](#features) • [Install](#install) • [Documentation] • [Contribute](#contribute)

![Doom Nvim demo](./assets/demo.png)

</div>

---

### Table of Contents

- [Introduction](#introduction)
- [Acknowledgements](#acknowledgements)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Install](#install)
- [Getting help](#getting-help)
- [Contribute](#contribute)

# Introduction

<a href="http://ultravioletbat.deviantart.com/art/Yay-Evil-111710573">
  <img src="https://raw.githubusercontent.com/hlissner/doom-emacs/screenshots/cacochan.png" align="right" />
</a>

> It is a story as old as time. A barely new vimmer that is afraid to configure
> Neovim and make it work out-of-the-box without problems, that gets the
> solution to his configuration problems. This is his configuration.

Doom Nvim is a Neovim port of the [doom-emacs](https://github.com/hlissner/doom-emacs) framework.
Its goal is to add useful functions to Neovim to start working in a stable and efficient
development environment without spending a lot of time configuring everything.

Its design is guided by these mantras:

- **Gotta go fast.** Startup and run-time performance are priorities.
  That is why Doom Nvim uses Lua instead of Vimscript for its configurations
  and searches for tiny but powerful plugins.
- **Your system, your rules.** You know better than a third party what is
  convenient for you. At least, Doom hopes so! It won't _automatically_
  install system dependencies (and will force plugins not to do so either if
  they have any external dependencies).

# Acknowledgements

- [hlissner](https://github.com/hlissner) per doing Doom Emacs :heart:.
- [romgrk](https://github.com/romgrk) per doing a port to Vim of Doom One
  colorscheme from Doom Emacs.

# Features

- Minimalistic good looks inspired by modern code editors.
- Curated and sane defaults for many packages.
- A modular organizational structure for separating concerns in your config.
- A declarative and powerful [package management system]
  (powered by `packer.nvim`).
- Opt-in LSP integration for many languages by using the new
  built-in LSP included on Neovim Nightly.
- Support for _almost_ all programming languages with a very short startup time
  because it automatically detects which one to load based on the filetype!
- An Emacs which-key like plugin to manage your `keybindings`, centered around leader
  prefix key (<kbd>SPC</kbd>).
- Per-file indentation style detection and [editorconfig] integration. Let
  someone else argue about tabs vs **_spaces_**.
- Project-management tools.
- Project search (and more) utilities, powered by
  [telescope.nvim].

# Prerequisites

- Curl 7.x
- Git 2.23+
- Neovim Nightly 0.5.0 (see [Doom Nvim FAQ][faq] to know why Doom Nvim don't provide support for Neovim 0.4)
- GNU `find`
- _OPTIONALS:_
  - [ripgrep] 11.0+ or [fd] 7.3.0+ (improves file indexing performance for some commands)
  - `nodejs` and `npm` (required to use the built-in LSP)

Doom is comprised of [~40 optional plugins][modules], some of which may have
additional dependencies. [Please visit their documentation][modules].

# Install

Simply run the following command:

```sh
curl -sLf https://raw.githubusercontent.com/NTBBloodbath/doom-nvim/main/install.sh | bash
```

Then [read our Getting Started guide][getting-started] to be walked through
installing, configuring and maintaining Doom Nvim.

> NOTE: If you want to see all the available commands in the installation script, then use
> <kbd>bash -s -- -h</kbd> instead of just <kbd>bash</kbd>

# Getting help

Neovim is not very difficult. Although you will occasionally run into problems
if you are not an advanced vimmer. When you do, here are some places you can look help:

- [Our documentation][documentation] covers many use cases.
  - [The Configuration section][configuration] covers how to configure Doom Nvim and
    its modules.
  - [The Package Management section][package-management] covers how to install
    and disable modules.
- Search the [Doom Nvim's issue tracker](https://github.com/NTBBloodbath/doom-nvim/issues)
  before opening a new issue to see if your issue was already been reported and to
  avoid duplicating issues.

# Contribute

- I really :heart: pull requests and bug reports (please see the [Contributing Guidelines][contribute] before contributing)!
- Don't hesitate to [tell me my Lua coding style sucks](https://github.com/NTBBloodbath/doom-emacs/issues/new),
  but please tell me why (I am new to Lua, I may have some bad practices that can be fixed in code).

[contribute]: docs/contributing.md
[documentation]: docs/README.md
[faq]: docs/faq.md
[getting-started]: docs/getting_started.md
[install]: docs/getting_started.md#install
[configuration]: docs/getting_started.md#configuring-doom
[package-management]: docs/getting_started.md#package-management
[modules]: docs/modules.md
[editorconfig]: http://editorconfig.org/
[fd]: https://github.com/sharkdp/fd
[ripgrep]: https://github.com/BurntSushi/ripgrep
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
