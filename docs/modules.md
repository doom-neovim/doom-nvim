# Doom Nvim Modules

- [Doom Nvim Modules](#doom-nvim-modules)
  * [Introduction](#introduction)
  * [All modules](#all-modules)
    + [`core` modules](#-core--modules)
    + [`features` modules](#-features--modules)
    + [`langs` modules](#-langs--modules)
  * [Configuring modules](#configuring-modules)
    + [Quick Guide](#quick-guide)
    + [Advanced guide](#advanced-guide)
      - [Module lifecycle](#module-lifecycle)
      - [Limitations](#limitations)
        * [Direct plugin access](#direct-plugin-access)
        * [Conditional keybinds and autocommands](#conditional-keybinds-and-autocommands)
      - [Module spec](#module-spec)
  * [Implementing your own doom module](#implementing-your-own-doom-module)
    + [1. Setting up](#1-setting-up)
    + [2. Adding autocommands](#2-adding-autocommands)
    + [3. Enabling and testing your module](#3-enabling-and-testing-your-module)
    + [4. Adding the character counter](#4-adding-the-character-counter)
    + [5. Adding commands to get and reset the count](#5-adding-commands-to-get-and-reset-the-count)
    + [6. Adding keybinds](#6-adding-keybinds)
    + [7. Adding and lazyloading a plugin](#7-adding-and-lazyloading-a-plugin)
    + [8. Exposing settings to the user](#8-exposing-settings-to-the-user)
    + [9. You're done!  Final output](#9-you-re-done---final-output)

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
  - [`todo_comments`](../lua/doom/modules/features/todo_comments) Highlights TODO comments and more
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
  - [`netrw`](../lua/doom/modules/features/netrw) Native file explorer in the sidebar
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
- [`svelte`](../lua/doom/modules/langs/svelte)
- [`rust`](../lua/doom/modules/langs/rust)
- [`cpp`](../lua/doom/modules/langs/cpp)
- [`c_sharp`](../lua/doom/modules/langs/c_sharp)
- [`kotlin`](../lua/doom/modules/langs/kotlin)
- [`java`](../lua/doom/modules/langs/java)
- [`go`](../lua/doom/modules/langs/go)
- [`config`](../lua/doom/modules/langs/config) Adds JSON, YAML, TOML support
- Missing a language? Submit a feature request issue.

## Configuring modules

### Quick Guide

You can access, override and configure all modules by using the `config.lua` file (`<leader>Dc` or `~/.config/nvim/config.lua`).
This is done through the `doom.features` global object.  Here we'll use the [`comment`](../lua/doom/modules/features/comment) module as an example.
Compare the source file with the example overrides below.

```lua
--- config.lua

-- Here `comment_module` is just a reference to `../lua/doom/modules/features/comment/init.lua`
local comment_module = doom.features.comment
-- Override default settings (provided by doom-nvim)
comment_module.settings.padding = false
-- Override package source with a fork
comment_module.packages['Comment.nvim'] = {
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

### Advanced guide
<!-- TODO: Proof-read and finalise this section -->

#### Module lifecycle
1. Doom nvim reads `modules.lua` to determine which modules to load.
2. Doom loads the config for each module, saves it to `doom.features|doom.langs|doom.core` global object.
3. User can override the settings for a module in `config.lua` using the `doom.modules` global object.
4. Doom executes the modules, installing plugins and setting keybinds/autocommands.

#### Limitations

##### Direct plugin access

The main limitation is that plugins are not yet loaded when `config.lua` is executed meaning you
cant have direct access to plugins. We're working on a more concrete solution but for now you can
splice your own custom configure function with the default one.

```lua
--- config.lua

local lsp = doom.langs.lsp
local old_nvim_cmp_config_function = lsp.configs['nvim-cmp']
lsp.configs['nvim-cmp'] = function()
  old_nvim_cmp_config_function() -- Run the default config
  local cmp = require("cmp") -- direct access to plugin
end
```

##### Conditional keybinds and autocommands

Sometimes keybinds and autocommands will be conditionally added/disabled depending on if another module
is enabled or if a specific config option is set.  In this case we use a function that returns a valid config
instead of a simple table.

This is not ideal as it's harder to `vim.inspect` the defaults.  As a workaround you can `vim.inspect` the returned value.

```lua
-- config.lua

print(type(doom.features.lsp.binds)) -- "table" (not conditional)
print(vim.inspect(doom.features.lsp.binds)) -- Shows config
print(type(doom.features.telescope.binds)) -- "function" (adds extra keybinds if "lsp" module is enabled)
print(vim.inspect(doom.features.telescope.binds())) -- You must execute the function to see the config.
```

#### Module spec

These are the possible values a

```lua
module.settings:  table                             -- Table of settings that can be tweaked
module.packages:      table<string,table<PackerSpec>>   -- Table of packer specs
module.configs:   table<string,function>            -- Table of plugin config functions relating to the packer specs
module.binds:     table<NestConfig>|function -> table<NestConfig> -- Table of NestConfig or function that returns Table of NestConfig
module.autocmds:  table<AutoCmd>|function -> table<AutoCmd>       -- Table of AutoCmds (see below) or function that returns a table of AutoCmds
```

```lua
local example = {}

example.settings = {...} -- Doom-nvim provided object to change settings

-- Stores the packer.nvim config for all of the plugin dependencies
example.packages = {
  ["example-plugin.nvim"] = { -- Use the repository name as the key
    "GithubUser/example-plugin.nvim",
    commit = "..." -- We like to pin plugins to commits to avoid issues upgrading.
  }
}

example.configs = {
  ["example-plugin.nvim"] = function() -- key matches `example.packages` entry
    require('example-plugin').setup( doom.features.example.settings ) -- Consumes `example.settings` and uses it to config the plugin
  end
}

-- Keybinds are defined using a modified nest.nvim table syntax.
-- https://github.com/connorgmeehan/nest.nvim/tree/integrations-api
example.binds = {
  { '<leader>ff', '<cmd>:Telescope find_files<CR>', name = 'Find files'} -- `name = "..."` For `whichkey` and `mapper` integrations
  { '<leader>cc', function() print('custom command') end, name = 'Find files' }, -- Can trigger either a `<cmd>` string or a function
}

-- If you need conditional keybinds it's recommended you use a function that returns a table instead.
example.binds = function()
  local binds = { ... }
  if doom.features.other_module then
    table.insert(binds, {
      '<leader>ff', function() print('this is a conditional keybind') end, name = 'My conditional keybind'
    })
  end
  return binds
end

-- Autocmds are defined as a table with the following syntax
-- { "event", "aupat", "command or function" }
-- Example
example.autocmds = {
  { "BufWinEnter", "*.js", function() print("I'm in a javascript file now") end }
}
-- Similarly, autocmds can be conditional using a function
example.autocmds = function()
  local autocmds = {}
  if condition then
    table.insert(autocmds, { "BufWinEnter", "*.js", function() print("I'm in a javascript file now") end })
  end
  return autocmds
end
```

## Building your own module

I will use an example of implementing a module that counts the number of chars that you've typed.
This module will:
  - Use autocommands to count the number of chars in a buffer when you enter insert mode vs when you leave insert mode
  - Add it to an accumulated sum
  - Provide keybinds + commands to restart or display total count
  - Use a plugin to display the results in a popup window
  - Include some settings to change the displayed output

### 1. Setting up

> Because modules are implemented as folders with an `init.lua` inside, they must be named after valid folder names.
> Best practices are:
> - Seperate words with an underscore, this is so the plugin can be represented as a lua variable
> - Name the module after the functionality rather than the plugin it uses.

For our example of adding char counting plugin I will create a folder called `lua/user/modules/features/char_counter/`
and create a new `init.lua` inside of it.
```lua
-- lua/user/modules/features/char_counter/init.lua
local char_counter = {}

return char_counter
```

### 2. Adding autocommands

> Autocommands are set using the `module_name.autocmds` field.  And follow the structure of
> ```lua
> module_name.autocmds = {
>   { "{event}", "{aupat}", "command or function" }
> }
> ```

For our example we need to hook into the [InsertEnter](https://neovim.io/doc/user/autocmd.html#InsertEnter)
and [InsertLeave](https://neovim.io/doc/user/autocmd.html#InsertLeave) auto commands.

```lua
-- lua/user/modules/features/char_counter/init.lua
char_counter.autocmds = {
  { "InsertEnter", "*", function ()
    print('Entered insert mode')
  end},
  { "InsertLeave", "*", function ()
    print('Exited insert mode')
  end},
}
```

### 3. Enabling and testing your module

Now you can enable the module in `modules.lua`!  Once enabled, restart your doom-nvim instance and check
`:messages` to see if it's printing correctly.

```lua
-- modules.lua
return {
  features = {
    'char_counter',
  },
}
```

### 4. Adding the character counter

Because modules are just tables, you can add any properties or functions that you need to the module table.
To implement the character counter we will add a few fields to the module table.  Unless you want users to
access these fields we recommend prefixing them with an underscore.
1. A function that gets the character count of a buffer.
2. A field to store the character count when we enter insert mode.
3. A field to store the accumulated count when we exit insert mode.

We will also check if the [`buftype`](https://neovim.io/doc/user/options.html#'buftype') is empty, this
means we wont count other interactive buffers like terminals, prompts or quick fix lists.

```lua
-- lua/user/modules/features/char_counter/init.lua

local char_counter = {}

char_counter._insert_enter_char_count = nil
char_counter._accumulated_difference = 0
char_counter._get_current_buffer_char_count = function()
  local lines = vim.api.nvim_buf_line_count(0)
  local chars = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, lines, false)) do
    chars = chars + #line
  end
  return chars
end

char_counter.autocmds = {
  { "InsertEnter", "*", function ()
    -- Only operate on normal file buffers
    print(("buftype: %s"):format(vim.bo.buftype))
    if vim.bo.buftype == "" then
      -- Store current char count
      char_counter._insert_enter_char_count = char_counter._get_current_buffer_char_count()
    end
  end},
  { "InsertLeave", "*", function ()
    -- Only operate on normal file buffers
    if vim.bo.buftype == "" and char_counter._insert_enter_char_count then
      -- Find the amount of chars added or removed
      local new_count = char_counter._get_current_buffer_char_count()
      local diff = new_count - char_counter._insert_enter_char_count
      print(new_count, diff)
      -- Add the difference to the accumulated total
      char_counter._accumulated_difference = char_counter._accumulated_difference + diff
      print(('Accumulated difference %s'):format(char_counter._accumulated_difference))
    end
  end},
}

return char_counter
```

### 5. Adding commands to get and reset the count

Using the `module.cmds` property we can define and expose vim commands to the user.  Here we will define a
`:CountPrint` and `:CountReset` command.

```lua
-- lua/user/modules/features/char_counter/init.lua

char_counter.cmds = {
  { "CountPrint", function ()
    local msg = ("char_counter: You have typed %s characters since I started counting."):format(char_counter._accumulated_difference)
    vim.notify(msg, "info")
  end},
  { "CountReset", function ()
    char_counter._accumulated_difference = 0
    vim.notify("char_counter: Reset count!", "info")
  end}
}
```
> **NOTE**: Instead of using a function you can also provide a string that will be executed using `vim.cmd`

Now restart doom nvim and run `:CountPrint` and `:CountReset` to test it out.

### 6. Adding keybinds

Keybinds are provided using the `module.binds` field.  We use a modified [nest.nvim]() config that integrates with whichkey and nvim-mapper. You can read more about it [here](https://github.com/connorgmeehan/nest.nvim/tree/integrations-api#quickstart-guide) but generally you should provide the `name` field for all entries so it displays in whichkey.

```lua
-- lua/user/modules/features/char_counter/init.lua

char_counter.binds = {
  { '<leader>i', name = '+info', { -- Adds a new `whichkey` folder called `+info`
    { 'c', '<cmd>:CountPrint<CR>', name = 'Print new chars' }, -- Binds `:CountPrint` to `<leader>ic`
    { 'r', '<cmd>:CountReset<CR>', name = 'Reset char count' } -- Binds `:CountPrint` to `<leader>ic`
  } }
}
```
> **NOTE**: Instead of a cmd you can also provide a lua function that will be executed when the keybind is triggered.

### 7. Adding and lazyloading a plugin

Plugins are added using the `module.packages` field and are configured using the `module.configs` field.
We use the repository name as a key to connect the plugin to its config function.
The API for `module.packages` is passed to Packer nvim's use function. [DOCS](https://github.com/wbthomason/packer.nvim#specifying-plugins)

In this example I will add [nui.nvim](https://github.com/MunifTanjim/nui.nvim) to display the results in a popup when
the user uses the `CountPrint` command.

```lua
-- lua/user/modules/features/char_counter/init.lua

-- Add these two fields to `char_counter` at the top of the file.
char_counter.packages = {
  ["nui.nvim"] = {
    "MunifTanjim/nui.nvim",
    cmd = { "CountPrint" } -- Here, nui.nvim wont be loaded until user does the `<leader>ic` or `:CountPrint` command.
  }
}

char_counter.configs = {
  ["nui.nvim"] = function()
    -- Log when nui loads so we can check that it's being lazy loaded correctly
    vim.notify("char_counter: nui.nvim loaded", "info")

    -- If your plugin requires a `.setup({ ... config ... })` function, this is where you'd execute it.

    -- WARNING: Because of how Packer compiles plugin configs, this function does not have direct access to `char_counter` table.
    -- The only way to access the `char_counter` object is via `doom.features.char_counter`
  end
}

-- Modify `char_counter.cmds`

char_counter.cmds = {
  { "CountPrint", function ()
    -- We can ensure that nui has loaded due to the `cmd = { "CountPrint" }` in the plugin's config
    local Popup = require('nui.popup')

    local popup = Popup({
      position = '50%',
      size = {
        width = 80,
        height = 40,
      },
      border = {
        padding = {
          top = 2,
          bottom = 2,
          left = 3,
          right = 3,
        },
      },
      style = "rounded",
      enter = true,
      buf_options = {
        modifiable = true,
        readonly = true,
      }
    })
    popup:mount()
    popup:map("n", "<esc>", function() popup:unmount() end)

    local msg = ("char_counter: You have typed %s characters since I started counting."):format(char_counter._accumulated_difference)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { msg })
  end},
  { "CountReset", function ()
    char_counter._accumulated_difference = 0
    vim.notify("char_counter: Reset count!", "info")
  end}
}
```

### 8. Exposing settings to the user

In order to keep doom-nvim flexible, it's best practice to expose settings for the module.  A common practice is just to expose the entire config
object.  This will allow users to tweak the config in their `config.lua` file without replacing and rewriting all of the logic for a small change.


```lua
-- lua/user/modules/features/char_counter/init.lua

-- Copy the settings that are passed to the `Popup` function, place them in `char_counter.settings.popup`
char_counter.settings = {
  popup = {
    position = '50%',
    size = {
      width = 80,
      height = 40,
    },
    border = {
      padding = {
        top = 2,
        bottom = 2,
        left = 3,
        right = 3,
      },
    },
    style = "rounded",
    enter = true,
    buf_options = {
      modifiable = true,
      readonly = true,
    }
  }
}

-- Modify the Popup function
char_counter.cmds = {
  { "CountPrint", function ()
    local Popup = require('nui.popup')

    local popup = Popup(char_counter.settings.popup) -- Configured via the `settings.popup` field.

    popup:mount()
    popup:map("n", "<esc>", function() popup:unmount() end)

    local msg = ("char_counter: You have typed %s characters since I started counting."):format(char_counter._accumulated_difference)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { msg })
  end},
  { "CountReset", function ()
    char_counter._accumulated_difference = 0
    vim.notify("char_counter: Reset count!", "info")
  end}
}
```

### 9. Contributing your module upstream

> Builtin modules are loaded from the `lua/doom/modules/` folder.  Within this folder there is a `features/`, `langs/` and `core/` directory.
> If you look at [`modules.lua`](../modules.lua) you'll see that the table fields are used to lookup the subfolder.
```lua
return {
  features = {
    "lsp" -- Maps to `lua/doom/modules/features/lsp/`,
  },
  langs = {
    "lua" -- Maps to `lua/doom/modules/langs/lua/`
  }
}
```

If you would like to contribute your module, just move it from `lua/user/modules/<module_name>` to
`lua/user/modules/<langs|features>/<module_name>` and create a PR in accordance with our [Contributing Guidelines](./contributing.md).

### 10. You're done!  Final output

If you'd just like to look at the end result, or if you're comparing why your implementation didn't work, here is the final working output.

```lua
-- lua/user/modules/features/char_counter/init.lua
local char_counter = {}

char_counter.settings = {
  popup = {
    position = '50%',
    size = {
      width = 80,
      height = 40,
    },
    border = {
      padding = {
        top = 2,
        bottom = 2,
        left = 3,
        right = 3,
      },
    },
    style = "rounded",
    enter = true,
    buf_options = {
      modifiable = true,
      readonly = true,
    }
  }
}

char_counter.packages = {
  ["nui.nvim"] = {
    "MunifTanjim/nui.nvim",
    cmd = { "CountPrint" }
  }
}

char_counter.configs = {
  ["nui.nvim"] = function()
    vim.notify("char_counter: nui.nvim loaded", "info")
  end
}

char_counter._insert_enter_char_count = nil
char_counter._accumulated_difference = 0
char_counter._get_current_buffer_char_count = function()
  local lines = vim.api.nvim_buf_line_count(0)
  local chars = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, lines, false)) do
    chars = chars + #line
  end
  return chars
end

char_counter.autocmds = {
  { "InsertEnter", "*", function ()
    -- Only operate on normal file buffers
    print(("buftype: %s"):format(vim.bo.buftype))
    if vim.bo.buftype == "" then
      -- Store current char count
      char_counter._insert_enter_char_count = char_counter._get_current_buffer_char_count()
    end
  end},
  { "InsertLeave", "*", function ()
    -- Only operate on normal file buffers
    if vim.bo.buftype == "" and char_counter._insert_enter_char_count then
      -- Find the amount of chars added or removed
      local new_count = char_counter._get_current_buffer_char_count()
      local diff = new_count - char_counter._insert_enter_char_count
      print(new_count, diff)
      -- Add the difference to the accumulated total
      char_counter._accumulated_difference = char_counter._accumulated_difference + diff
      print(('Accumulated difference %s'):format(char_counter._accumulated_difference))
    end
  end},
}

char_counter.cmds = {
  { "CountPrint", function ()
    local Popup = require('nui.popup')
    local popup = Popup(char_counter.settings.popup)
    popup:mount()
    popup:map("n", "<esc>", function() popup:unmount() end)

    local msg = ("char_counter: You have typed %s characters since I started counting."):format(char_counter._accumulated_difference)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { msg })
  end},
  { "CountReset", function ()
    char_counter._accumulated_difference = 0
    vim.notify("char_counter: Reset count!", "info")
  end}
}

char_counter.binds = {
  { '<leader>i', name = '+info', { -- Adds a new `whichkey` folder called `+info`
    { 'c', '<cmd>:CountPrint<CR>', name = 'Print new chars' }, -- Binds `:CountPrint` to `<leader>ic`
    { 'r', '<cmd>:CountReset<CR>', name = 'Reset char count' } -- Binds `:CountPrint` to `<leader>ic`
  } }
}

return char_counter
```
