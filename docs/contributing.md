# Contributing

Since Doom Nvim is an active and barely new port, maintained mostly by a single
person, there may be things that need doing, mostly features that need
implementing, and documentation that needs documenting.

You are welcome to contribute with anything to improve Doom Nvim, but please
look at [contributing code](#contributing-code) to know better how to contribute
and which code style you should use :heart:

> **Working on your first Pull Request?** You can learn how from this *free* series
> [How to Contribute to an Open Source Project on GitHub](https://kcd.im/pull-request).

# Table of Contents

- [Where can I help?](#where-can-i-help)
- [Reporting issues](#reporting-issues)
  - [Acquire a backtrace from errors](#acquire-a-backtrace-from-errors)
  - [Create a step-by-setp reproduction guide](#create-a-ste-by-step-reproduction-guide)
  - [Include information about your Doom Nvim install](include-information-about-your-doom-nvim-install)
- [Suggesting features, keybinds and enhancements](#suggesting-features-keybinds-and-enhancements)
- [Contributing code](#contributing-code)
  - [Conventions](#conventions)
    - [Code style](#code-style)
    - [Commits & PRs](#commits--prs)
    - [Keybind conventions](#keybind-conventions)
  - [Submitting pull requests](#submitting-pull-requests)

# Where can I help

- If you’ve encountered a bug, [file a bug report](https://github.com/NTBBloodbath/doom-nvim/issues/new/choose).
- Check out our [issue tracker](https://github.com/NTBBloodbath/doom-nvim/issues)
  for reported issues. If you find one that you have an answer for, that would
  be a great help!
- Look for issues tagged [help wanted](https://github.com/NTBBloodbath/doom-nvim/labels/help%20wanted).
  These tend to be a little (or a lot) harder, and are issues outside my own expertise.
- If you are a Windows user and you are interested in contributing to Doom Nvim
  so that it works correctly on your environment, you can do it freely since I
  currently do not have that system to do tests.

# Reporting issues

## Acquire a backtrace from errors

All the errors ocurred in Doom Nvim are saved into a `doom.log` file inside your
Doom Nvim root dir (`$HOME/.config/doom-nvim` by default). If the logs are very long, please
paste it using a [gist].

> **NOTE:** Alternatively you can paste the most recent lines starting with the
> following if the logs are extremely long.
>
> [!] - Errors
> 
> [!!!] - Critical errors

## Create a step-by-step reproduction guide

A step-by-step guide can help considerably to debug the error that occurs and
thus reach a solution more quickly.

## Include information about your Doom Nvim install

Some important data would be:
- Your Neovim version
- Your custom configuration if you have one (`$HOME/.config/doom-nvim/doomrc`)
- Which branch of Doom Nvim are you using
- Which plugins are you using

# Suggest features, keybinds and enhancements

- To request a new feature, please use the prefix `[Feature Request]` in your issue.
- To request a keybind, please use the prefix `[Keybind Request]` in your issue.
- To request an enhancement, please use the prefix `[Enhancement]` in your issue.

In this way, it is much easier and more organized to identify the
type of issue and handle the requests.

# Contributing code

## Conventions

### Code style

Doom Nvim follows some code style rules like ones the mentioned below:

- Single quotes instead of double quotes.
- Variable names in `snake_case`, except in the BASH installation script.
- Function names in `snake_case`, the only exception are the Vimscript functions
  which does not are from doom itself, e.g. `function ToggleTerm() ... endfunction`.

### Commits & PRs

- Target `develop-nightly` instead of `main`.
  the only exception are hotfixes!

### Keybind conventions

- The keybindings should be declared in [config/keybindings](../config/keybindings.vim),
  except when they are keybindings of the [leader-mapper](../config/plugins/leader-mapper.vim)
  or keybindings of [Lua plugins](../lua/configs).

## Submitting pull requests

After having made all your changes and having tested them locally to certify that
they work and do not break any of the current code, you can proceed to upload
your pull request :)
