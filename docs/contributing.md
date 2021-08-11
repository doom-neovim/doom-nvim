# Contributing

Since Doom Nvim is an active and barely new port, maintained mostly by a single
person, there may be things that need doing, mostly features that need
implementing, and documentation that needs documenting.

You are welcome to contribute with anything to improve Doom Nvim, but please
look at [contributing code](#contributing-code) to know better how to contribute
and which code style you should use :heart:

> **Working on your first Pull Request?** You can learn how from this _free_ series
> [How to Contribute to an Open Source Project on GitHub](https://kcd.im/pull-request).

## Where can I help

- If you’ve encountered a bug, [file a bug report](https://github.com/NTBBloodbath/doom-nvim/issues/new/choose).
- Check out our [issue tracker](https://github.com/NTBBloodbath/doom-nvim/issues)
  for reported issues. If you find one that you have an answer for, that would
  be a great help!
- Look for issues tagged [help wanted](https://github.com/NTBBloodbath/doom-nvim/labels/help%20wanted).
  These tend to be a little (or a lot) harder, and are issues outside my own expertise.
- If you are a Windows user and you are interested in contributing to Doom Nvim
  so that it works correctly on your environment, you can do it freely since I
  currently do not have that system to do tests.

## Jumping between two branches

If you have a personal branch and then a second branch only made for creating PRs
you will most likely have to remove the `plugin/packer_compiled.lua` file every
time you checkout the `pull_request_branch`. This is because the pr branch most likely
will have less settings and plugins than you personal branch and therefore it will
not work as expected otherwise. Eg. you will see 'Dashboard' text on vim load instead of
'Doom'.

## Reporting issues

### Acquire a backtrace from errors

All the errors ocurred in Doom Nvim are saved into a `doom.log` file inside the
`~/.local/share/nvim/` directory. If the logs are very long, please paste it
using a [gist].

### Create a step-by-step reproduction guide

A step-by-step guide can help considerably to debug the error that occurs and
thus reach a solution more quickly.

### Include information about your Doom Nvim install

Some important data would be:

- Your custom configuration if you have one
  (`doomrc.lua`, `doom_config.lua` and `plugins.lua`)
- Which branch of Doom Nvim are you using
- Which plugins are you using

## Suggest features, keybinds and enhancements

- To request a new feature, please use the prefix `Feature request:` in your issue.
- To request a keybind, please use the prefix `Keybind request:` in your issue.
- To request an enhancement, please use the prefix `Enhancement:` in your issue.

In this way, it is much easier and more organized to identify the
type of issue and handle the requests.

## Contributing code

### Conventions

#### Code style

Doom Nvim follows some code style rules like ones the mentioned below:

- Double quotes over single quotes.
- Spaces over tabs.
- Variable names in `snake_case`, except in the BASH installation script.
- Function names in `snake_case`.
- [stylua] is used to format lua files with the following configuration:

```toml
column_width = 100
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferDouble"
```

> **NOTE:** use `--config-path /path/to/doom/nvim/stylua.toml` to use doom's
> stylua configuration.

- [selene] is a blazing-fast modern Lua linter written in Rust which is used for
  linting doom's source code. We make use of some custom rules so we can be sure
  that selene will not raise false errors.

> **NOTE:** use `selene .` in doom's root dir and selene will automatically
> detect the `selene.toml` and `doom.toml` files.

#### Commits & PRs

- Target `develop` instead of `main`.
  The only exception are hotfixes!

#### Keybind conventions

- The keybindings should be declared in [extras/keybindings](../lua/doom/extras/keybindings/init.lua),
  except when they are keybindings of [Lua plugins](../lua/doom/modules/config).

### Submitting pull requests

After having made all your changes **and having tested them locally to certify that**
**they work and do not break any of the current code**, you can proceed to upload
your pull request :)

[gist]: https://gist.github.com/
[stylua]: https://github.com/JohnnyMorganz/StyLua
[selene]: https://github.com/Kampfkarren/selene
