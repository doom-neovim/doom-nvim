local utils = require("doom.utils")
local is_module_enabled = utils.is_module_enabled

local utils_ui = {}

-- @param input method
-- 		nui | telescope | regular vim input
-- @param selection_table
-- 		the table which you can choose from if eg. telescope
-- @param callback
-- 		pass ui results to callback function
-- @return str
-- 		typed_input_str
-- @return str
-- 		fuzzy_match_str_if_telescope
utils_ui.spawn_input = function(kind, selection_table, callback) end

-- install fzf with exact matching into telescope -> https://github.com/nvim-telescope/telescope-fzf-native.nvim
local function spawn_telescope_picker_on_table(target_table, callback)
  -- map each entry back to the target_table
  local selection_to_target_table_map = {}

  for _, v in ipairs[target_table] do
    selection_to_target_table_map[ui_repr_map(v,bufnr)] = v
  end

  print(vim.inspect(selection_to_target_table_map))

  local function pass_telescope_entry_to_callback(prompt_bufnr)
    local state = require("telescope.actions.state")
    local input_str = state.get_current_line(prompt_bufnr)
    local fuzzy_selection = state.get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_bufnr)

    print(input_str, fuzzy_selection.value)

    if input_str == fuzzy_selection.value then
      print("open file: ", input_str)
    else
      print("create module: ", input_str)
    end

    callback(fuzzy_selection.value)
  end

  -- local function telescope_refactoring(opts)
  opts = opts or require("telescope.themes").get_cursor()

  -- TODO: pass absolute match instead of fuzzy
  require("telescope.pickers").new(opts, {
    prompt_title = "create user module",
    finder = require("telescope.finders").new_table({
      results = target_table,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", pass_telescope_entry_to_callback)
      map("n", "<CR>", pass_telescope_entry_to_callback)
      return true
    end,
  }):find()
  -- end
end

local function spawn_nui_input(callback)
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event
  local input = Input(create_module.settings.popup, {
    prompt = "> ",
    default_value = "42",
    on_close = function()
      print("Input closed!")
    end,
    on_submit = function(value)
      callback(value)
    end,
    on_change = function(value)
      print("Value changed: ", value)
    end,
  })
  input:mount()
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

return utils_ui
