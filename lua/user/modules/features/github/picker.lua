local octo_cfg = require("octo.config").defaults
local telescope_conf = require("telescope.config").values
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local entry_display = require("telescope.pickers.entry_display")

--- Read the key mapping from octo.nvim
--- then convert it to flat table which sutable for display in Telescope
---@param mappings: the key mapping from Octo
---@return flatted data
local function flat(mappings)
  local flatted = {}
  -- loop through all the mappings
  for topic, commands in pairs(mappings) do
    for func, command in pairs(commands) do
      table.insert(flatted, { topic = topic, func = func, lhs = command.lhs, desc = command.desc })
    end
  end

  return flatted
end

local mapping = octo_cfg.mappings
local flatted_mapping = flat(mapping)

--- Format the layout to display in telescope (Result pane)
---@param entry : represent each row in the result
---@return
local make_display = function(entry)
  -- print("called make_display", vim.inspect(entry))
  if not entry then
    return nil
  end

  local columns = {
    { entry.object.topic, "TelescopeResultsNumber" },
    { entry.object.func, "TelescopeResultsFunction" },
    { entry.object.desc, "TelescopeResultsNumber" },
    { entry.object.lhs, "TelescopeResultsNumber" },
    -- { entry.ordinal, "TelescopeResultsNumber" },
  }

  local displayer = entry_display.create({
    separator = " | ",
    items = {
      { width = 20 },
      { width = 25 },
      { width = 50 },
      { remaining = true },
    },
  })

  return displayer(columns)
end

--- Prepare the data for each row in the Telescope result pane
---@param entry
---@return
local entry_maker = function(entry)
  -- print("called entry_maker", (entry))
  return {
    display = make_display,
    value = entry.desc,
    ordinal = entry.topic .. entry.func .. entry.desc, -- text use for filter
    object = entry,
  }
end

local close_picker = function(prompt_bufnr)
  local selection = require("telescope.actions.state").get_selected_entry()
  actions.close(prompt_bufnr)
  local func_to_call = selection.object.func
  local m = require("octo.mappings")
  m[func_to_call]()
end

--- Create the picker to select a function from Octo
---@return
local function create_picker()
  pickers
    .new({}, {
      prompt_title = "Octo operations",
      finder = finders.new_table({
        results = flatted_mapping, -- The result set, find by the finder
        entry_maker = entry_maker, -- formating the result
      }),
      sorter = telescope_conf.generic_sorter(),
      attach_mappings = function(prompt_bufnr, map)
        -- <CR> will close the picker
        map("i", "<CR>", close_picker)
        map("n", "<CR>", close_picker)
        return true
      end,
    })
    :find()
end

return {
  show = create_picker,
}
