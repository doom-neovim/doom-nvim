local lua = {}

lua.defaults = {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "doom" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  dev = {
    library = {
      vimruntime = true,
      types = true,
      plugins = true,
    },
  },
}

lua.packer_config = {}
lua.packer_config["lua-dev.nvim"] = function()
  require("lua-dev").setup(doom.lua.dev)
end

return lua
