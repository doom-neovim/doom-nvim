-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--
--
-- create a bind for each entry according to the readme.

local textobjects = {}

textobjects.packages = {
  ["nvim-treesitter-textobjects"] = { "nvim-treesitter/nvim-treesitter-textobjects" },
}

textobjects.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  textobjects.binds = {
    {
      "<leader>v",
      name = "+testing",
      {
        {
          "t",
          name = "+treesitter",
          {
            {
              "o",
              name = "+textobjects",
              {
                { "p", "<cmd>TSPlaygroundToggle<CR>", name = "togl playgr" },
              },
            },
          },
        },
      },
    },
  }
end

return textobjects
