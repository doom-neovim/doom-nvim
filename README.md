
<div align="center">

# Doom Nvim

![License](https://img.shields.io/github/license/NTBBloodbath/doom-nvim?style=for-the-badge)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](http://makeapullrequest.com)
![Latest Release](https://img.shields.io/github/v/release/NTBBloodbath/doom-nvim?include_prereleases&style=for-the-badge&color=red)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/NTBBloodbath/doom-nvim/develop?style=for-the-badge)
![Neovim version](https://img.shields.io/badge/Neovim-0.5-57A143?style=for-the-badge&logo=neovim)
[![Discord](https://img.shields.io/badge/discord-join-7289da?style=for-the-badge&logo=discord)](https://discord.gg/xhvBM45zBf)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-14-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

![Doom Nvim demo](https://i.imgur.com/ejEnlEP.png)

</div>

---

- [Doom Nvim](#doom-nvim)
  * [What is Doom Nvim?](#what-is-doom-nvim-)
  * [Install](#install)
  * [Configuring](#configuring)
    + [`modules.lua`](#-moduleslua-)
      - [What is a module?](#what-is-a-module-)
      - [Enabing/disabling modules](#enabing-disabling-modules)
      - [All modules](#all-modules)
    + [`config.lua`](#-configlua-)
      - [Modifying neovim and doom options](#modifying-neovim-and-doom-options)
        * [Adding plugins](#adding-plugins)
        * [Adding Keybinds](#adding-keybinds)
        * [Adding autocommands](#adding-autocommands)
      - [Overriding module defaults](#overriding-module-defaults)
  * [FAQ](#faq)
  * [Contributing](#contributing)
  * [Contributors](#contributors)

---

## What is Doom Nvim?

Doom Nvim is a Neovim interpretation of the [doom-emacs](https://github.com/hlissner/doom-emacs) framework, adapted to Vim philosophy.

Its goal is to provide a configurable, extensible, performant and stable basis for any neovim configuration.
Some of the defining features that make this project unique are:

- **Fast** Rapid startup time without defer_fn, packages are lazy loaded and languages are only configured when opening the file type.
- **Stable** Plugins are pinned to commit shas to avoid breaking between updates.
- **Configurable** All modules are 100% overridable and configurable, use a logical structure and have LSP completions.
- **Integrated** Desgined to handle and setup integrations between plugins for you.  For example, whichkey will only show keybinds for
  modules you have enabled (and will automatically handle your custom bindings).
- **Extensible** Take advantage of the modular architecture, enable only the features you need, customise or add your own modules.

## Install

TODO: Add install docs here

## Configuring

Doom nvim is configured by enabling modules in the `modules.lua` file and then tweaking, overriding or adding new packages, keybinds and more within the `config.lua` module.

### `modules.lua`

#### What is a module?
A module is a collection of packages, autocommands, keybinds and functions that add new capabilities or functionality to Doom Nvim.
We organise modules into 3 categories:
- `features` extend the abilities of Doom Nvim by adding new functionality.
- `langs` add support for new languages.
- `user` (**optional**) You can create and enable your own modules without modifying the Doom Nvim source code (read more)[#TODO:].

#### Enabing/disabling modules

You can enable or disable a module by going to `modules.lua` (`<leader>Dm`) and commenting or uncommenting the entry.
```lua
-- modules.lua
return {
  features = {
    'lsp'
    -- 'telescope'
  },
  langs = {
    'lua',
    -- 'rust',
  }
}
```
> Here the `lsp` module is enabled but the `telescope` module is disabled, similarly the `lua` language is enabled but the `rust`
> language module is disabled.

#### All modules

Doom-nvim currently has 39 `features` modules and 14 `langs` modules.  Some standout features are:
- `lsp` Code completions provided by `nvim-cmp`
- `linter` Formatting and linting provided by `null-ls.nvim`
- `whichkey` Interactive cheatsheet that integrates with our keybind management to **only show keybinds for modules you have active**
- `fidget` Shows LSP loading/indexing progress status

You can find a full list of modules (here)[#TODO: ].

### `config.lua`

#### Modifying neovim and doom options

Doom nvim provides a number of config options, including wrapping some of vim's own options.  See all available config options (here)[TODO:].

```lua
-- config.lua
doom.freeze_dependencies = false  -- Don't use pinned packer dependencies
doom.logging = 'trace'            -- Debug doom internal issues
doom.indent = 2                   -- Sets vim.opt.shiftwith, vim.opt.softtabstop, vim.opt.tabstop to 2

vim.opt.colorcolumn = 120         -- Regular vim options can also be set
```

> **NOTE:** If you have the `lua` language and `lsp` module enabled all of these options will be autocompleted.

##### Adding plugins

Additional packages can be imported with the `doom.use()` function.
This is a wrapper around `packer.use()` and provides the same API. [DOCS](https://github.com/wbthomason/packer.nvim#quickstart)

```lua
-- Simple config
doom.use('sainnhe/sonokai', 'EdenEast/nightfox.nvim')

-- Advanced config
doom.use({
  'rafcamlet/nvim-luapad',
  opt = true,
  cmd = 'Luapad'
})
```

##### Adding Keybinds

Additional keybinds can be defined with the `doom.bind()` function.
This is a wrapper around a custom `nest.nvim` implementation and provides the same API. [DOCS](https://github.com/connorgmeehan/nest.nvim/tree/integrations-api#quickstart-guide)

```lua
doom.bind({
  { '<leader>u', name = '+user', { -- Names this group in whichkey "+user"
    { 's', '<cmd>Telescope git_status<CR>', name = 'Git status' } -- Adds `<leader>us` keybind to trigger `Telescope git_status`
  }},
})
```

> **NOTE:** By providing the `name` field your custom keybinds will show up in `whichkey` and `mapper` if you have those modules enabled.

##### Adding autocommands

Additional autocommands can be defined with the `doom.autocmd()` function.

```lua
doom.autcmd({
  -- { "<event>", "<aupat>", "<command or function>"}
  { "FileType", "javascript", function() print('Yuck!') end}
})
```

#### Overriding module defaults

The settings and config for all modules are also exposed inside of the `doom` global object.
Here you can override the plugin git sources, pre-defined settings, keybinds or autocmds.


```lua
-- modules.lua
return {
  features = {
    'whichkey' -- Whichkey module is enabled
  }
}

-- config.lua
local whichkey = doom.modules.whichkey -- Get the whichkey module

-- Some common settings are exposed in the `<module>.settings` table.
whichkey.settings.window.height.max = 5

-- Inspect the existing config
print(vim.inspect(whichkey))

-- Add an additional keybind
table.insert(whichkey.binds, { '<leader>u', name = '+user', {
    { "wr", function() require("which-key").reset(), name = "Reset whichkey"}
  }
})
-- Replace all keybinds
whichkey.binds = {
  { '<leader>u', name = '+user', {
    { "wr", function() require("which-key").reset(), name = "Reset whichkey"}
  }}
}

-- Add an additional autocommand
table.insert(whichkey.autcmds, { "event", "aupat", "cmd"})
-- Replace all autocommands
whichkey.autocmds = {
  { "event", "aupat", "cmd"}
}

-- Modify the plugin source repo, plugins are indexed via the repository name.
whichkey.uses["which-key.nvim"] = {
    "myfork/which-key.nvim"
}
-- Provide a different config function, the key has to match the entry in `whichkey.uses`
whichkey.configs["which-key.nvim"] = function ()
  local wk = require("which-key")
end
```

## FAQ

TODO: Add FAQ

## Contributing

For for information please see our [contributing docs](./docs/contributing.md).

## Contributors

Special thanks to these amazing people for helping improve doom (see [emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://johnirle.com/"><img src="https://avatars.githubusercontent.com/u/11879736?v=4?s=100" width="100px;" alt=""/><br /><sub><b>John Irle</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=JohnIrle" title="Documentation">📖</a></td>
    <td align="center"><a href="http://www.brianketelsen.com/"><img src="https://avatars.githubusercontent.com/u/37492?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Brian Ketelsen</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=bketelsen" title="Code">💻</a> <a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3Abketelsen" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/Samantha-uk"><img src="https://avatars.githubusercontent.com/u/45871296?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Samantha-uk</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=Samantha-uk" title="Documentation">📖</a></td>
    <td align="center"><a href="https://rscircus.github.io/"><img src="https://avatars.githubusercontent.com/u/1167114?v=4?s=100" width="100px;" alt=""/><br /><sub><b>rscircus</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=rscircus" title="Documentation">📖</a></td>
    <td align="center"><a href="http://bandithedoge.com/"><img src="https://avatars.githubusercontent.com/u/26331682?v=4?s=100" width="100px;" alt=""/><br /><sub><b>bandithedoge</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=bandithedoge" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/vhyrro"><img src="https://avatars.githubusercontent.com/u/76052559?v=4?s=100" width="100px;" alt=""/><br /><sub><b>vhyrro</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=vhyrro" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Mremmalex"><img src="https://avatars.githubusercontent.com/u/40169444?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ifeanyichukwu Sampson Ebenezer</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3AMremmalex" title="Bug reports">🐛</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/GustavoPrietoP"><img src="https://avatars.githubusercontent.com/u/70907734?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Gustavo Prieto</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=GustavoPrietoP" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ZeusThundr"><img src="https://avatars.githubusercontent.com/u/76399616?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ZeusThundr</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3AZeusThundr" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/leonistor"><img src="https://avatars.githubusercontent.com/u/310468?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Leo Nistor</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3Aleonistor" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/notusknot"><img src="https://avatars.githubusercontent.com/u/69602000?v=4?s=100" width="100px;" alt=""/><br /><sub><b>notusknot</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=notusknot" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/bdillahu"><img src="https://avatars.githubusercontent.com/u/2058566?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Bruce Dillahunty</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=bdillahu" title="Documentation">📖</a> <a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3Abdillahu" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/amxj9"><img src="https://avatars.githubusercontent.com/u/2029709?v=4?s=100" width="100px;" alt=""/><br /><sub><b>amxj9</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/issues?q=author%3Aamxj9" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/AceMouty"><img src="https://avatars.githubusercontent.com/u/45374681?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kyle Guerrero</b></sub></a><br /><a href="https://github.com/NTBBloodbath/doom-nvim/commits?author=AceMouty" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

