# Doom Nvim Modules

## Introduction

Doom Nvim consists of around 40 plugins and growing.
A Doom Nvim module is a bundle of packages, configurations, autocommands and
binds, organized into a unit that can be toggled easily.

Modules are grouped into 3 categories:
- `features` (optional, extend doom-nvim with extra capabilities)
- `langs` (optional, add support for a language)
- `core` (cannot be disabled, required for core functionality).

 You can enable or disable doom modules by commenting them out in the `modules.lua` file
(`<leader>Dm` or `~/.config/nvim/modules.lua`).

## All modules

### `core` modules

- [`treesitter`](../lua/doom/modules/core/treesitter) An incremental parsing system for programming tools.
- [`nest`](../lua/doom/modules/core/nest) Used for keybind management, integrates with `whichkey` and `mapper`.

### `features` modules

- **Language related modules**
  - [`annotations`](../lua/doom/modules/features/annotations) Code annotation generator
  - [`auto_install`](../lua/doom/modules/features/auto_install) Auto install LSP providers
  - [`autopairs`](../lua/doom/modules/features/autopairs) Automatically close character pairs
  - [`comment`](../lua/doom/modules/features/comment) Generate comments in any language.
  - [`linter`](../lua/doom/modules/features/linter) Format and lint your code
  - [`snippets`](../lua/doom/modules/features/snippets) Code snippets for all languages

- **Editor modules**
  - [`auto_session`](../lua/doom/modules/features/auto_session) Return to previous sessions
  - [`colorizer`](../lua/doom/modules/features/colorizer) Show colors in editor
  - [`editorconfig`](../lua/doom/modules/features/editorconfig) .editorconfig file support
  - [`gitsigns`](../lua/doom/modules/features/gitsigns) Show changes near linenumber
  - [`illuminate`](../lua/doom/modules/features/illuminate) Highlight other occurances of the hovered word
  - [`indentlines`](../lua/doom/modules/features/indentlines) Explicitly show indentation
  - [`range_highlight`](../lua/doom/modules/features/range_highlight) Highlight selected range as you type commands
  - [`todo_comments`](../lua/doom/modules/features/todo_comments) Highlights TODO: comments and more
- **UI modules**
  - [`fidget`](../lua/doom/modules/features/fidget) Shows LSP loading status
  - [`tabline`](../lua/doom/modules/features/tabline) Tabbed buffer switcher
  - [`dashboard`](../lua/doom/modules/features/dashboard) A pretty dashboard upon opening doom-nvim.
  - [`trouble`](../lua/doom/modules/features/trouble) A pretty diagnostics viewer
  - [`minimap`](../lua/doom/modules/features/minimap) Shows current position in document
  - [`whichkey`](../lua/doom/modules/features/whichkey) An interactive keybind cheatsheet
- **Tool modules**
  - [`dap`](../lua/doom/modules/features/dap) Debug adapter protocol for neovim
  - [`explorer`](../lua/doom/modules/features/explorer) File explorer in the sidebar
  - [`neorg`](../lua/doom/modules/features/neorg) Organise your life
  - [`telescope`](../lua/doom/modules/features/telescope) Search files, text, commands and more
  - [`projects`](../lua/doom/modules/features/projects) Quick project switching

<!--
  TODO: Add remaining modules
-->

### `langs` modules

- [`lua`](../lua/doom/modules/langs/lua) Lua language support, we recommend keeping this enabled as it also provides LSP completion for all config options.
- [`python`](../lua/doom/modules/langs/python)
- [`bash`](../lua/doom/modules/langs/bash)
- [`javascript`](../lua/doom/modules/langs/javascript)
- [`typescript`](../lua/doom/modules/langs/typescript)
- [`css`](../lua/doom/modules/langs/css)
- [`vue`](../lua/doom/modules/langs/vue)
- [`tailwindcss`](../lua/doom/modules/langs/tailwindcss)
- [`rust`](../lua/doom/modules/langs/rust)
- [`cpp`](../lua/doom/modules/langs/cpp)
- [`c_sharp`](../lua/doom/modules/langs/c_sharp)
- [`kotlin`](../lua/doom/modules/langs/kotlin)
- [`java`](../lua/doom/modules/langs/java)
- [`config`](../lua/doom/modules/langs/config) Adds JSON, YAML, TOML support
- Missing a language? Submit a feature request issue.

## Configuring modules

### Quick Guide

You can access, override and configure all modules by using the `config.lua` file (`<leader>Dc` or `~/.config/nvim/config.lua`).
This is done through the `doom.modules` global object.  Here we'll use the [`comment`](../lua/doom/modules/features/comment) module as an example.
Compare the source file with the example overrides below.
```lua
--- config.lua

-- Here `comment_module` is just a reference to `../lua/doom/modules/features/comment/init.lua`
local comment_module = doom.modules.comment
-- Override default settings (provided by doom-nvim)
comment_module.settings.padding = false
-- Override package source with a fork
comment_module.uses['Comment.nvim'] = {
  'my_fork/Comment.nvim',
  module = "Comment"
}
-- If you need more customisability than overriding the settings, you can override the configure function
comment_module.configs["Comment.nvim"] = function () end
-- Replace keybinds
comment_module.binds = {
  { "gc", "<cmd>echo Do something<CR>", name = "Comment motion"}
}
```

> **NOTE:** If you have the `lua` language module and `lsp` feature module enabled,
all of these properties should be auto completeable.

### Advanced
<!-- TODO: Proof-read and finalise this section -->

#### Limitations

#### Module lifecycle
1. Modules are defined in `modules.lua`.
2. Doom loads the config for each module, saves it to `doom.modules`.
3. User can override the settings for a module in `config.lua`
4. Doom executes the module, loads and installs the dependencies, sets the keybinds and autocommands.

#### Module spec

These are the possible values a

```lua
module.settings:  table                             -- Table of settings that can be tweaked
module.uses:  table<string,table<PackerSpec>>   -- Table of packer specs
module.configs:   table<string,function>            -- Table of plugin config functions relating to the packer specs
module.binds:     table<NestConfig>|function -> table<NestConfig> -- Table of NestConfig or function that returns Table of NestConfig
module.autocmds:  table<AutoCmd>|function -> table<AutoCmd>       -- Table of AutoCmds (see below) or function that returns a table of AutoCmds
```

```lua
local module = {}

module.settings = {...} -- Doom-nvim provided object to change settings

-- Stores the packer.nvim config for all of the plugin dependencies
module.uses = {
  ["example-plugin.nvim"] = { -- Use the repository name as the key
    "GithubUser/example-plugin.nvim",
    commit = "..." -- We like to pin plugins to commits to avoid issues upgrading.
  }
}

module.configs = {
  ["example-plugin.nvim"] = function() -- key matches `module.uses` entry
    require('example-plugin').setup( doom.modules.example.settings ) -- Consumes `module.settings` and uses it to config the plugin
  end
}

-- Keybinds are defined using a modified nest.nvim table syntax.
-- https://github.com/connorgmeehan/nest.nvim/tree/integrations-api
module.binds = {
  { '<leader>ff', '<cmd>:Telescope find_files<CR>', name = 'Find files'} -- `name = "..."` For `whichkey` and `mapper` integrations
  { '<leader>cc', function() print('custom command') end, name = 'Find files' }, -- Can trigger either a `<cmd>` string or a function
}

-- If you need conditional keybinds it's recommended you use a function that returns a table instead.
module.binds = function()
  local binds = { ... }
  if doom.modules.other_module then
    table.insert(binds, {
      '<leader>ff', function() print('this is a conditional keybind') end, name = 'My conditional keybind'
    })
  end
  return binds
end

-- Autocmds are defined as a table with the following syntax
-- { "event", "aupat", "command or function" }
-- Example
module.autocmds = {
  { "FileType", "javascript", function() print("I'm in a javascript file now") end }
}
-- Similarly, autocmds can be conditional using a function
module.autocmds = function()
  local autocmds = {}
  if condition then
    table.insert(autocmds, { "FileType", "javascript", function() print("I'm in a javascript file now") end })
  end
  return autocmds
end
```
