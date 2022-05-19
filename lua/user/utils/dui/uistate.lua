-- local utils = require("doom.utils")

-- local pu =  require("user.utils.dui.utils")
local pickers = require("user.utils.dui.pickers")

local uistate = {}

function uistate.ensure_doom_ui_state()

  doom_ui_state = {
    -- doom_global_extended,
    all_modules_flattened = nil,
    selected_module_idx = nil, -- is this necessary?
    selected_module = nil,
    selected_component = nil,
    buf_ref = nil,


    current = {
      title = nil, -- remove and do in picker
      results_prepared = nil, -- remove and do in picker
      picker = nil, -- remove
      selection = { item = nil, type = nil },
      line_str = nil,
      index_selected = nil,
    },

    history = {},
  }

end

function uistate.reset_selections()
  doom_ui_state.selected_module = nil
  doom_ui_state.current = nil
end

function uistate.doom_ui_state_reset()
  doom_ui_state = nil
end

-- function uistate.doom_ui_state_reset_modules()
--     doom_ui_state.all_modules_flattened = pu.get_modules_flattened()
-- end

function uistate.next()

  -- print(vim.inspect(doom_ui_state.current))

  -- local store = vim.deepcopy(doom_ui_state.current)

  -- doom_ui_state.prev = store

  -- table.insert(doom_ui_state.history, 1, store)
  -- local hlen = #doom_ui_state.history
  -- if hlen > 10 then
  --   table.remove(doom_ui_state.history, hlen)
  -- end

  if picker ~= nil then picker() end
end

function uistate.prev_hist()
  local res = table.remove(doom_ui_state.history, 1)
  if res ~= nil then
    doom_ui_state.prev = res
    doom_ui_state.prev.picker()
  end
end

return uistate
