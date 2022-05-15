local utils = require("doom.utils")

local tdr = {}

-- local refactoring = require("refactoring")

-- -- refactoring helper
-- local function refactor(prompt_bufnr)
--     local content = require("telescope.actions.state").get_selected_entry(
--         prompt_bufnr
--     )
--     require("telescope.actions").close(prompt_bufnr)
--     refactoring.refactor(content.value)
-- end

-- local function telescope_refactoring(opts)
--     opts = opts or require("telescope.themes").get_cursor()
--
--     require("telescope.pickers").new(opts, {
--         prompt_title = "refactors",
--         finder = require("telescope.finders").new_table({
--             results = refactoring.get_refactors(),
--         }),
--         sorter = require("telescope.config").values.generic_sorter(opts),
--         attach_mappings = function(_, map)
--             map("i", "<CR>", refactor)
--             map("n", "<CR>", refactor)
--             return true
--         end,
--     }):find()
-- end

tdr.cmds = {
  {
    "DoomPluginsReloadPicker",
    function()

      local opts = {}

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local action_set = require("telescope.actions.set")
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry")
      local pickers = require("telescope.pickers")
      local previewers = require("telescope.previewers")
      local sorters = require("telescope.sorters")
      local utils = require("telescope.utils")
      local conf = require("telescope.config").values
      local log = require("telescope.log")

      local package_list = vim.tbl_keys(package.loaded)

      -- filter out packages we don't want and track the longest package name
      local column_len = 0
      for index, module_name in pairs(package_list) do
        if
          type(require(module_name)) ~= "table"
          or module_name:sub(1, 1) == "_"
          or package.searchpath(module_name, package.path) == nil
        then
          table.remove(package_list, index)
        elseif #module_name > column_len then
          column_len = #module_name
        end
      end
      opts.column_len = vim.F.if_nil(opts.column_len, column_len)

      pickers.new(opts, {
        prompt_title = "Packages",
        finder = finders.new_table({
          results = package_list,
          -- entry_maker = opts.entry_maker or make_entry.gen_from_packages(opts),
        }),
        -- previewer = previewers.vim_buffer.new(opts),
        sorter = conf.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            if selection == nil then
              print("[telescope] Nothing currently selected")
              return
            end

            actions.close(prompt_bufnr)
            require("plenary.reload").reload_module(selection.value)
            print(string.format("[%s] - module reloaded", selection.value))
          end)

          return true
        end,
      }):find()
    end,
  },
}

return tdr
