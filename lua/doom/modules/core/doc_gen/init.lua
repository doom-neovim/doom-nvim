--
---@text # `doom.core.doc_gen`
---
--- Internal module for generating doom-nvim documentation.
---
--- Most of the parsing and helpdoc generation logic is handled by mini.doc.
--- The markdown - support is added by patching and overriding the default
--- behaviour [check mini_doc_config.lua](./mini_doc_config.lua).
---
--- Although this is a "core" module it is not enabled by default.  To enable it
--- you must add the `core` field to your `modules.lua` file.
---
--- ```lua
--- -- modules.lua
--- return {
---   core = {
---     "required", -- Must include all other core modules
---     "nest",
---     "reloader",
---     "treesitter",
---     "updater",
---     "doc_gen", -- Add "doc_gen" module
---   }
--- }
--- ```

local doc_gen = {}

---@toc_entry doc_gen.settings
---@text ## Settings
---
--- Settings for the `doom.core.doc_gen` module.
---
---@eval return doom.core.doc_gen.generate_settings(MiniDoc.current.eval_section)
doc_gen.settings = {
  --The desired output format, this will configure mini
  --@type 'helpdoc'|'markdown'
  --@default 'helpdoc'
  output_format = "markdown",
}
---minidoc_afterlines_end

---@toc_entry doc_gen.packages
---@eval return doom.core.doc_gen.generate_packages_documentation("core.doc_gen")
doc_gen.packages = {
  ["mini_doc"] = {
    "echasnovski/mini.doc",
  },
}

doc_gen.configs = {}
doc_gen.configs["mini_doc"] = require('doom.modules.core.doc_gen.mini_doc_config')

---@toc_entry doc_gen.binds
---@text ## Keybinds
---
--- Keybinds for the doc_gen module.
---
---@eval return doom.core.doc_gen.generate_keybind_table(doom.core.doc_gen.binds)
doc_gen.binds = {
  {
    "<leader>Dg",
    function()
      local output_ft = doc_gen.settings.output_format == "markdown" and "md" or "txt"
      require("mini.doc").generate({ vim.fn.expand("%") }, ("test.%s"):format(output_ft), {})
    end,
    name = "Document current file",
  },
}

---@toc_entry doc_gen.cmds
---
---@eval return doom.core.doc_gen.generate_commands_documentation("core.doc_gen")
doc_gen.cmds = {
  {
    "GenerateMarkdownDocCurrentFile",
    function()
      local output_ft = doc_gen.settings.output_format == "markdown" and "md" or "txt"
      require("mini.doc").generate({ vim.fn.expand("%") }, ("%s/index.md"):format(vim.fn.expand("%:h"), output_ft), {})
    end,
    name = "Document current file",
  },
}

--- Given a module's `binds` field, returns a string of a formatted markdown table
--- documenting all the keymaps
---@param binds table | function
doc_gen.generate_keybind_table = function(binds_field)
  local keymaps = type(binds_field) == "function" and binds_field() or binds_field
  local doc_integration = require("doom.modules.core.doc_gen.keybind_doc_integration")
  doc_integration.clear()

  doc_integration.set_table_fields({
    { key = "lhs", name = "Keybind" },
    { key = "name", name = "Name" },
  })
  local keymaps_service = require("doom.services.keymaps")
  keymaps_service.traverse(keymaps, nil, { doc_integration })
  return doc_integration.print_markdown()
end

doc_gen.generate_command_table = function(commands_field)
  local commands = type(commands_field) == "function" and commands_field() or commands_field
end

--- Generates
---@param path string Path to module from doom global object i.e. "core.doc_gen"
doc_gen.generate_commands_documentation = function(path)
  local segments = vim.split(path, "%.")
  local module = doom[segments[1]][segments[2]]

  if module then
    local result = {
      "## Commands",
      "",
    }
    if module.cmds and #module.cmds > 0 then
      table.insert(
        result,
        table.concat({
          ("Commands for the `doom.%s.%s` module."):format(segments[1], segments[2]),
          "",
          "Note: Plugins may create additional commands, these will be avaliable once",
          "the plugin loads.  Please check the docs for these [plugins](#plugins-packages).",
        }, "\n")
      )

      local table_data = {}
      for _, spec in ipairs(module.cmds) do
        table.insert(table_data, {
          cmd = ("`:%s`"):format(spec[1]),
          description = spec["description"] or "",
        })
      end

      table.insert(
        result,
        require("doom.modules.core.doc_gen.table_printer").print(
          table_data,
          { "cmd", "description" },
          { "Command", "Description" }
        )
      )
    else
      table.insert(result, "This module does not create any commands.")
    end
    return table.concat(result, "\n")
  end
  return ""
end
--- Generates
---@param path string Path to module from doom global object i.e. "core.doc_gen"
doc_gen.generate_autocmds_documentation = function(path)
  local segments = vim.split(path, "%.")
  local module = doom[segments[1]][segments[2]]

  if module then
    local result = {
      "## Commands",
      "",
    }
    if module.cmds and #module.cmds > 0 then
      table.insert(
        result,
        table.concat({
          ("Commands for the `doom.%s.%s` module."):format(segments[1], segments[2]),
          "",
          "Note: Plugins may create additional commands, these will be avaliable once",
          "the plugin loads.  Please check the docs for these [plugins](#plugins-packages).",
        }, "\n")
      )

      local table_data = {}
      for _, spec in ipairs(module.cmds) do
        table.insert(table_data, {
          event = spec[1],
          pattern = spec[2],
          description = spec["description"] or "",
        })
      end

      table.insert(
        result,
        require("doom.modules.core.doc_gen.table_printer").print(
          table_data,
          { "cmd", "description" },
          { "Command", "Description" }
        )
      )
    else
      table.insert(result, "This module does not create any commands.")
    end
    return table.concat(result, "\n")
  end
  return ""
end
--- Generates
---@param path string Path to module from doom global object i.e. "core.doc_gen"
doc_gen.generate_packages_documentation = function(path)
  local segments = vim.split(path, "%.")
  local module = doom[segments[1]][segments[2]]

  if module then
    local pkg_names = vim.tbl_keys(module.packages)
    local result = {
      "## Plugins/Packages",
      "",
    }
    if #pkg_names > 0 then
      local first_package = pkg_names[1]
      table.insert(
        result,
        table.concat({
          ("Plugins for the `doom.%s.%s` module."):format(segments[1], segments[2]),
          "",
          "These plugins will be passed into packer.nvim on startup.  You can tweak",
          "the packer options by accessing these values in your `config.lua` file.",
          "i.e.:",
          "```lua",
          ("local %s_packages = doom.%s.%s.packages"):format(segments[2], segments[1], segments[2]),
          ("%s_packages['%s'].commit = '<my_new_commit_sha>'"):format(segments[2], first_package),
          "```",
        }, "\n")
      )

      local table_data = {}
      for name, spec in pairs(module.packages) do
        local is_lazy = spec["opt"]
          or spec["cmd"] ~= nil
          or spec["autocmd"] ~= nil
          or spec["keys"] ~= nil
          or spec["ft"] ~= nil
        table.insert(table_data, {
          id = ("`%s`"):format(name),
          source = ("[%s](https://github.com/%s)"):format(spec[1], spec[1]),
          commit = spec["commit"] and ("[%s](https://github.com/%s/commit/%s)"):format(
            string.sub(spec["commit"], 8),
            spec[1],
            spec["commit"]
          ) or "N/A",
          lazy = is_lazy and "✅" or "",
        })
      end

      table.insert(
        result,
        require("doom.modules.core.doc_gen.table_printer").print(
          table_data,
          { "id", "source", "commit", "lazy" },
          { "Key", "Source", "Commit", "Is Lazy?" }
        )
      )
    else
      table.insert(result, "This module does not use any plugins.")
    end
    return table.concat(result, "\n")
  end
  return ""
end

-- Generates settings documentation for a settings block
--@param struct table The mini.doc struct
--@return string (is appended to doc)
doc_gen.generate_settings = function(struct)
  local temp = vim.deepcopy(struct)
  temp.parent = nil
  if struct.type == "section" then
    struct = struct.parent
  end
  local src = table.concat(struct.info.afterlines, "\n")
  return "```lua\n" .. src .. "\n```"
end

return doc_gen
