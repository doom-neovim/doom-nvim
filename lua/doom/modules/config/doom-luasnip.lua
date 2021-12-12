return function()
  local mappings = require("doom.utils.mappings")
  local luasnip = require("luasnip")

  luasnip.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
  })

  require("luasnip/loaders/from_vscode").load()

  --- <tab> to jump to next snippet's placeholder
  local function on_tab()
    return luasnip.jump(1) and "" or mappings.t("<Tab>")
  end

  --- <s-tab> to jump to next snippet's placeholder
  local function on_s_tab()
    return luasnip.jump(-1) and "" or mappings.t("<S-Tab>")
  end

  mappings.imap("<Tab>", on_tab, { expr = true })
  mappings.smap("<Tab>", on_tab, { expr = true })
  mappings.imap("<S-Tab>", on_s_tab, { expr = true })
  mappings.smap("<S-Tab>", on_s_tab, { expr = true })
end
