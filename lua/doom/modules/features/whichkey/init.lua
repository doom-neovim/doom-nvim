local whichkey = {}

whichkey.settings = {
  leader = " ",
  plugins = {
    marks = false,
    registers = false,
    presets = {
      operators = false,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  operators = {
    d = "Delete",
    c = "Change",
    y = "Yank (copy)",
    ["g~"] = "Toggle case",
    ["gu"] = "Lowercase",
    ["gU"] = "Uppercase",
    [">"] = "Indent right",
    ["<lt>"] = "Indent left",
    ["zf"] = "Create fold",
    ["!"] = "Filter though external program",
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  window = {
    padding = { 0, 0, 0, 0 },
    border = doom.settings.border_style,
  },
  layout = {
    height = { min = 1, max = 10 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = true,
  hidden = {
    "<silent>",
    "<Cmd>",
    "<cmd>",
    "<Plug>",
    "call",
    "lua",
    "^:",
    "^ ",
  },
  show_help = true,
  triggers = "auto",
}

whichkey.packages = {
  ["which-key.nvim"] = {
    "folke/which-key.nvim",
    commit = "e4fa445065a2bb0bbc3cca85346b67817f28e83e",
    keys = { "<leader>" },
  },
}

-- TODO: Not happy with how messy the integrations are.  Refactor!
whichkey.configs = {}
whichkey.configs["which-key.nvim"] = function()
  vim.g.mapleader = doom.features.whichkey.settings.leader

  local wk = require("which-key")

  wk.setup(doom.features.whichkey.settings)

  local get_whichkey_integration = function()
    --- @type NestIntegration
    local module = {}
    module.name = "whichkey"

    local keymaps = {}

    --- Handles each node of the nest keymap config (except the top level)
    --- @param node NestIntegrationNode
    --- @param node_settings NestSettings
    module.handler = function(node, node_settings)
      -- Only handle <leader> keys, which key needs a 'Name' field
      if node.lhs:find("<leader>") == nil or node.name == nil then
        return
      end

      for _, v in ipairs(vim.split(node_settings.mode or "n", "")) do
        if keymaps[v] == nil then
          keymaps[v] = {}
        end
        -- If this is a keymap group
        local rhs_type = type(node.rhs)
        if rhs_type == "table" then
          keymaps[v][node.lhs] = { name = node.name }
          -- If this is an actual keymap
        elseif rhs_type == "string" or rhs_type == "function" then
          keymaps[v][node.lhs] = { node.name }
        end
      end
    end

    module.on_complete = function()
      for k, v in pairs(keymaps) do
        require("which-key").register(v, { mode = k })
      end
      keymaps = {}
    end

    return module
  end

  local keymaps_service = require("doom.services.keymaps")
  local whichkey_integration = get_whichkey_integration()

  require("doom.utils.modules").traverse_loaded(
    doom.modules,
    function(node, stack)
      if node.type then
        local module = node
        if module.binds then
          keymaps_service.applyKeymaps(
            type(module.binds) == "function" and module.binds() or module.binds,
            nil,
            { whichkey_integration }
          )
        end
      end
    end
    --, { debug = doom.settings.logging == "trace" or doom.settings.logging == "debug" }
  )


  -- Add user keymaps to whichkey user keymaps
  if doom.binds and #doom.binds >= 1 then
    keymaps_service.applyKeymaps(doom.binds, nil, { whichkey_integration })
  end
end

return whichkey
