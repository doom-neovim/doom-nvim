
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
    + [Enabling features: `modules.lua`](#-moduleslua-)
      - [What is a module?](#what-is-a-module-)
      - [Enabing/disabling modules](#enabing-disabling-modules)
      - [All modules](#all-modules)
    + [Configuring and personalising: `config.lua`](#-configlua-)
      - [Modifying neovim and doom options](#modifying-neovim-and-doom-options)
        * [Adding plugins](#adding-plugins)
        * [Adding Keybinds](#adding-keybinds)
        * [Adding autocommands](#adding-autocommands)
        * [Adding commands](#adding-commands)
      - [Overriding module defaults](#overriding-module-defaults)
  * [FAQ](#faq)
  * [Contributing](#contributing)
  * [Contributors](#contributors)

---

## What is Doom Nvim?

Doom Nvim is a Neovim interpretation of the [doom-emacs](https://github.com/hlissner/doom-emacs) framework, adapted to Vim philosophy.

Our goal is to provide a configurable, extensible, performant and stable basis for any neovim configuration.
Some of the defining features that make this project unique are:

- **Fast** Rapid startup time without defer_fn, packages are lazy loaded and languages are only configured when opening its relevent file type.
- **Stable** Plugins are pinned to commit shas to avoid breaking between updates.
- **Scalable** Because of modular architecture you can disable any features you don't use.  Your config is as simple or complex as you want it to be.
- **Configurable** All modules are 100% overridable and configurable, use a logical structure and have LSP completions.
- **Extensible** With a simple api you can easily add, and or contribute, your own modules.
- **Integrated** Desgined to handle and setup integrations between plugins for you.  For example, whichkey will only show keybinds for
  modules you have enabled (and will automatically handle your custom bindings).

## Install

TODO: Add install docs here

## Configuring

Doom nvim is configured by enabling modules in the `modules.lua` file and then tweaking, overriding or adding new packages, keybinds and more within the `config.lua` module.

### Enabling features: `modules.lua`

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
> Here the `lsp` module is enabled but the `telescope` module is disabled,
> similarly the `lua` language is enabled but the `rust` language module is disabled.

#### All modules

Doom-nvim currently has 35+ `features` modules and 20+ `langs` modules.
You can find a full list of modules (here)[./docs/modules.md#all-modules]

### Configuring and personalising: `config.lua`

#### Modifying neovim and doom options

Doom nvim provides a number of config options, including wrapping some of vim's own options.  See all available config options (in the API Reference)[./docs/api.md].

```lua
-- config.lua

doom.settings.freeze_dependencies = false  -- Don't use pinned packer dependencies
doom.settings.logging = 'trace'            -- Debug doom internal issues
doom.settings.indent = 2                   -- Sets vim.opt.shiftwith, vim.opt.softtabstop, vim.opt.tabstop to 2

vim.opt.colorcolumn = 120         -- Regular vim options can also be set
```

> **NOTE:** If you have the `lua` language and `lsp` module enabled all of these options will be autocompleted.

##### Adding plugins

Additional packages can be imported with the `doom.use_package()` function.
This is a wrapper around `packer.use()` and provides the same API. [DOCS](https://github.com/wbthomason/packer.nvim#quickstart)

```lua
-- config.lua

-- Simple config
doom.use_package('sainnhe/sonokai', 'EdenEast/nightfox.nvim')

-- Advanced config
doom.use_package({
  'rafcamlet/nvim-luapad',
  opt = true,
  cmd = 'Luapad'
})
```

##### Adding Keybinds

Additional keybinds can be defined with the `doom.use_keybind()` function.
This is a wrapper around a custom `nest.nvim` implementation and provides the same API. [DOCS](https://github.com/connorgmeehan/nest.nvim/tree/integrations-api#quickstart-guide)

```lua
-- config.lua

doom.use_keybind({
  { '<leader>u', name = '+user', { -- Names this group in whichkey "+user"
    { 's', '<cmd>Telescope git_status<CR>', name = 'Git status' } -- Adds `<leader>us` keybind to trigger `Telescope git_status`
  }},
})
```

> **NOTE:** By providing the `name` field your custom keybinds will show up in `whichkey` and `mapper` if you have those modules enabled.

##### Adding autocommands

Additional autocommands can be defined with the `doom.use_autocmd()` function.

```lua
-- config.lua

doom.use_autocmd({
  -- { "<event>", "<aupat>", "<command or function>"}
  { "FileType", "javascript", function() print('Yuck!') end}
})
```

##### Adding commands

Additional commands can be define with the `doom.use_cmd()` function.

```lua
-- config.lua

-- Bind single
doom.use_cmd( { 'Test', function() print('test') end } )

-- Bind multiple
doom.use_cmd({
  { 'Test1', function() print('test1') end },
  { 'Test2', function() print('test2') end },
})
```

#### Configuring modules

The settings and config for all modules are also exposed inside of the `doom` global object.
Here you can override the plugin git sources, pre-defined settings, keybinds or autocmds.


Make sure that the module that you want to configure/override is enabled in `modules.lua`
```lua
-- modules.lua
return {
  features = {
    'whichkey' -- Whichkey module is enabled
  }
}
```

The same module with be avaliable in your `config.lua` in the `doom.features.module_name` field.
The settings should have autocomplete from sumneko lua lsp.
```lua
-- config.lua
local whichkey = doom.features.whichkey -- Get the whichkey module
-- You can also access it as `doom.modules.features.whichkey`

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
table.insert(whichkey.autocmds, { "event", "aupat", "cmd"})
-- Replace all autocommands
whichkey.autocmds = {
  { "event", "aupat", "cmd"}
}

-- Modify the plugin source repo, plugins are indexed via the repository name.
whichkey.packages["which-key.nvim"] = {
    "myfork/which-key.nvim"
}
-- Provide a different config function, the key has to match the entry in `whichkey.packages`
whichkey.configs["which-key.nvim"] = function ()
  local wk = require("which-key")
end

-- Another example with a language module
local lua = doom.langs.lua

-- Disable lua-dev loading library definitions
lua.settings.dev.library.plugins = false
```

#### Overriding modules or adding custom modules

It's possible to add your own doom modules or completely replace builtin doom
modules without editing the original files.  Doom will first check the `lua/user/modules`
directory if a module exists before loading the default from `lua/doom/modules`.

As an example, if we wanted to replace the `lua` module in the `langs` section we
would create a new file at `lua/user/modules/langs/lua/init.lua`.

Alternatively if we wanted to add support for a new language (lets use julia as
an example) we would create a new file at `lua/user/modules/langs/julia/init.lua`.
You would then enable the module in `modules.lua`

```lua
--- modules.lua
return {
  langs = {
    'julia',
  }
}
```

> For more info, read the [documentation for creating your own modules.](./docs/modules.md#building-your-own-module)

## Migration guide from v3

The majors changes between v3 and v4 are the following.

- `doom_config.lua` renamed to `config.lua`
- Adding custom commands, keybinds and autocommands done using new [`doom.use_*`](#-configlua-) helper functions.
- Adding extra plugins done using new [`doom.use_package`](#adding-plugins) helper function.
- `doom_modules.lua` renamed to `modules.lua`
- Many of the modules categories have been combined, there are now only `features` (modifying capabilities of doom-nvim) and `languages` (add support for a language)
- Languages `+lsp`, `+formatting`, etc flags are no longer necessary

> Because of the durastic changes to the way you configure doom-nvim we recommend
> starting a new branch and porting your changes across.

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

