-- try calling my yabai WM scripts from neovim here and see if it works.
--

-- notes on how to run shell commands in various ways
-- duck duck > https://duckduckgo.com/?q=neovim+execute+shell+command+user&ia=web
-- https://vi.stackexchange.com/questions/19705/how-can-i-emulate-shell-command-in-neovim
-- https://neovim.discourse.group/t/solved-what-is-the-correct-recommended-way-to-run-a-shell-command-in-neovim-in-the-background/2130
--
--
--
-- 1. create telescope picker for windows/apps available. > select target app/window.
-- 2. create new custom `wm` mode so that I can use regular keybinds to modify windows.
-- 3. leader > v > w -> wm_mode

-- -- code for refactoring tele ext:
-- -- USE THE BELOW TO SEE IF I CAN PIPE YABAI QUERIES INTO TELESCOPE?!
-- local refactoring = require("refactoring")
--
-- -- refactoring helper
-- local function refactor(prompt_bufnr)
--     local content = require("telescope.actions.state").get_selected_entry(
--         prompt_bufnr
--     )
--     require("telescope.actions").close(prompt_bufnr)
--     refactoring.refactor(content.value)
-- end
--
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
--
-- return require("telescope").register_extension({
--     exports = {
--         refactors = telescope_refactoring,
--     },
-- })

local wm = {}

wm.packages = {}



wm.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(wm.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "n",
        name = "+test",
        {
          {
            {
              "w",
              name = "+wm",
              { "c", [[ :lua print("wm hello")<cr> ]], name = "wm hello" },
            },
          },
        },
      },
    },
  })
end

return wm
