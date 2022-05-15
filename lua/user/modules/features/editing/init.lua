local editing = {}

editing.settings = {}

editing.packages = {
  ["vim-repeat"] = { "tpope/vim-repeat" },
  -- https://github.com/booperlv/nvim-gomove
  -- { 'luukvbaal/stabilize.nvim', config = function() require('stabilize').setup() end }, --???????????????
  -- https://github.com/sindrets/winshift.nvim
  -- https://github.com/nkakouros-original/numbers.nvim
	-- https://github.com/mizlan/iswap.nvim
}

editing.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(editing.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "f",
        name = "+file",
        {
          { "a", [[ :w!<cr> ]], name = "Force Save" },
          { "A", [[ :wall!<cr> ]], name = "Force Save All" },
        },
      },
    },
  })
end

return editing
