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
---@eval return doom.core.doc_gen.generate_settings_documentation(MiniDoc.current.eval_section, "core.doc_gen")
doc_gen.settings = {
  --The desired output format, this will configure mini
  --@type 'helpdoc'|'markdown'
  --@default 'helpdoc'
  output_format = "helpdoc",
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
doc_gen.configs["mini_doc"] = require("doom.modules.core.doc_gen.mini_doc_config")

---@toc_entry doc_gen.binds
---@text ## Keybinds
---
--- Keybinds for the doc_gen module.
---
---@eval return doom.core.doc_gen.generate_keybind_documentation("core.doc_gen")
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
    "GenerateDocCurrentFile",
    function()
      local relative_file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
      doc_gen.document_file(relative_file_path)
    end,
    description = "Generates markdown documentation in the doc folder.",
  },
  {
    "GenerateDocAll",
    function()
      doc_gen.document_file("lua/doom/modules/init.lua", "docs/modules/module_spec")
      for name, _ in pairs(doom.modules.langs) do
        doc_gen.document_file(("lua/doom/modules/langs/%s/init.lua"):format(name))
      end
      for name, _ in pairs(doom.modules.features) do
        doc_gen.document_file(("lua/doom/modules/features/%s/init.lua"):format(name))
      end
      for name, _ in pairs(doom.modules.core) do
        doc_gen.document_file(("lua/doom/modules/core/%s/init.lua"):format(name))
      end
    end,
    description = "Generates documentation for the entire framework",
  },
}

-- Generates documentation for all of doom-nvim
--@param path string Path of file to document
--@param destination string|nil Optional destination for the documentation
doc_gen.document_file = function(path, destination)
  local fs = require("doom.utils.fs")
  local folder = fs.split_file_path(path)
  -- Change from lua/ folder to docs/ folder
  folder = folder:gsub("lua/doom", "docs", 1)

  local output_format = doc_gen.settings.output_format
  folder = folder:sub(1, #folder - 1) -- Remove final /

  local output_ft = output_format == "markdown" and "md" or "txt"

  local dest = destination and ("%s.%s"):format(destination, output_ft)
      or ("%s.%s"):format(folder, output_ft)
  require("mini.doc").generate({ path }, dest, {})
end

--- Given a module's `binds` field, returns a string of a formatted markdown table
--- documenting all the keymaps
---@param path string
doc_gen.generate_keybind_documentation = function(path)
  local segments = vim.split(path, "%.")
  local module = doom[segments[1]][segments[2]]

  if module then
    local binds_field = module.binds
    local keymaps = type(binds_field) == "function" and binds_field() or binds_field
    local doc_integration = require("doom.modules.core.doc_gen.keybind_doc_integration")
    doc_integration.clear()

    local keymaps_service = require("doom.services.keymaps")
    keymaps_service.traverse(keymaps, nil, { doc_integration })
    local result = {
      "## Keybinds",
      "",
      "Override these keybinds in your config.lua:",
      "",
      "```lua",
      ("local %s = doom.%s.%s"):format(segments[2], segments[1], segments[2]),
      ("%s.binds = {"):format(segments[2]),
      '  { "<leader>prefix", "<cmd>echo \'my new keybind\'<CR>", name = "Description for my new keybind" }',
      "}",
      "```",
      "",
    }
    print("raw data: " .. vim.inspect(doc_integration.data))
    local formatted = vim.tbl_map(function(row)
      row.lhs = "`" .. row[1] .. "`"
      return row
    end, doc_integration.data)
    print("formatted: " .. vim.inspect(formatted))
    table.insert(
      result,
      require("doom.modules.core.doc_gen.table_printer").print(
        formatted,
        { "lhs", "name" },
        { "Keymap", "Description" }
      )
    )
    return result
  end
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
          "",
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
  local module = doom.modules[segments[1]][segments[2]]

  if module then
    local result = {
      "## Autocommands",
      "",
    }
    if module.autocmds and #module.autocmds > 0 then
      table.insert(
        result,
        table.concat({
          ("Autocommands for the `doom.%s.%s` module."):format(segments[1], segments[2]),
          "",
          "Note: Plugins may create additional autocommands, these will be avaliable once",
          "the plugin loads.  Please check the docs for these [plugins](#plugins-packages).",
          "",
        }, "\n")
      )

      local table_data = {}
      for _, spec in ipairs(module.autocmds) do
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
          { "event", "Event" },
          { "pattern", "Pattern" },
          { "description", "Description" }
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
  local output_format = doom.core.doc_gen.settings.output_format

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
          "",
          "```lua",
          ("local %s_packages = doom.%s.%s.packages"):format(segments[2], segments[1], segments[2]),
          ("%s_packages['%s'].commit = '<my_new_commit_sha>'"):format(segments[2], first_package),
          "```",
          "",
        }, "\n")
      )

      local table_data = {}
      for name, spec in pairs(module.packages) do
        local is_lazy = spec["opt"]
            or spec["cmd"] ~= nil
            or spec["autocmd"] ~= nil
            or spec["keys"] ~= nil
            or spec["ft"] ~= nil

        local source = output_format == "markdown"
            and ("[%s](https://github.com/%s)"):format(spec[1], spec[1])
            or spec[1]

        local commit = spec["commit"]
            and (output_format == "markdown" and ("[%s](https://github.com/%s/commit/%s)"):format(
              string.sub(spec["commit"], 8),
              spec[1],
              spec["commit"]
            ) or string.sub(spec["commit"], 8))
            or "N/A"
        table.insert(table_data, {
          id = output_format == "markdown" and ("`%s`"):format(name) or name,
          source = source,
          commit = commit,
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
doc_gen.generate_settings_documentation = function(struct, path)
  local segments = vim.split(path, "%.")
  local module = doom[segments[1]][segments[2]]

  if module then
    local res = {}
    table.insert(res, { "## Settings" })
    table.insert(res, { "" })
    table.insert(res, { ("Settings for the %s module."):format(segments[2]) })
    table.insert(res, { "" })
    table.insert(res, { "You can access and override these values in your `config.lua`. I.e." })
    table.insert(res, { "```lua" })
    table.insert(
      res,
      { ("local %s_settings = doom.%s.%s.settings"):format(segments[2], segments[1], segments[2]) }
    )
    table.insert(res, { ("%s_settings.<field> = <new_value>"):format(segments[2]) })
    table.insert(res, { "```" })
    local temp = vim.deepcopy(struct)
    temp.parent = nil
    if struct.type == "section" then
      struct = struct.parent
    end
    local src = table.concat(struct.info.afterlines, "\n")
    table.insert(res, "```lua\n" .. src .. "\n```")
    return vim.tbl_flatten(res)
  end
end

return doc_gen
