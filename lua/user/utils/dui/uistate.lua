local utils = require("doom.utils")

local uistate = {}

function uistate.ensure_doom_ui_state()
  if doom_ui_state ~= nil then return end

  -- 1. get doom modules extended
  -- 2. flatten_doom_modules()
  --

  -- inside a picker -> assign data to current
  -- in actions -> refer to history[#history] to get the selection.
  --
  -- always attach a type tage to result entries so that we can check for type
  -- when preparing pickers.

  doom_ui_state = {
    -- doom_global_extended,
    all_modules_flattened = nil,
    selected_module_idx = nil,
    current = {
      title = nil, -- eg. settings, modules, binds_table, binds_branch
      results_prepared = nil,
      buf_ref = nil,
      picker = nil,
      selection = { item = nil, type = nil },
      line_str = nil,
      index_selected = nil,
    },

    history = {},
  }
  doom_ui_state["prev"] = doom_ui_state.current
end

function uistate.reset_selections()
  doom_ui_state.selected_module = nil
  doom_ui_state.current = nil
end

function uistate.doom_ui_state_reset()
  doom_ui_state = nil
end

function uistate.doom_ui_state_reset_modules()
  local doom_modules_extended = utils.get_modules_flat_with_meta_data()
    doom_ui_state.all_modules_flattened = utils.get_modules_flattened(doom_modules_extended)
end

function uistate.next(picker)
  local prev_picker = doom_ui_state.current.picker
  -- if has userdata
  local dres, dsel, store
  if doom_ui_state.current.title:match("BIND") then
    dres = doom_ui_state.current.results_prepared
    dsel = doom_ui_state.current.selection
    doom_ui_state.current.results_prepared = nil
    doom_ui_state.current.selection = nil
    store = vim.deepcopy(doom_ui_state.current)
    store.results_prepared = dres
    store.selection = dsel
  else
    store = vim.deepcopy(doom_ui_state.current)
  end

  store.picker = prev_picker
  doom_ui_state.prev = store
  table.insert(doom_ui_state.history, 1, store)
  local hlen = #doom_ui_state.history
  if hlen > 10 then
    table.remove(doom_ui_state.history, hlen)
  end
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
