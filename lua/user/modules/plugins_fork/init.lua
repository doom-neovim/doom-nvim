local tsq = require("vim.treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local locals = require("nvim-treesitter.locals")
local api = vim.api
local cmd = api.nvim_command
local doom_queries = require("user.utils.doom_queries")
local user_ts_utils = require("user.utils.ts")

-- rename this module to `module_package_get_local`
--
-- XXX prepen text works
--
-- 	clone/fork?
-- 	toggle use local version?
--
-- 	picker select only NON-local package string (current situation)
--
-- 	picker for local -> set to regular.
--
-- 	compile all user-module-package-string-nodes into a telescope picker so that we can
-- 	select/toggle from a list of all packages that exists in doom.
--
--
-- redo the whole thing with `ARCHITEXT` plugin and see if it has streamlined my processes??

local pf = {}

pf.settings = {
  local_prefix = "doom.settings.local_plugins_path .. ",
}

local test_table = {}
test_table.packages = {
  "first/tttt_ss-st.nvim",
  ["first.aaa"] = { "second/t_e-rrr.aaa" },
  ["first"] = { "second/xxx", opt = true },
  ["firstX"] = { "second/rst.nnnnn", opt = true, arst = "arst" },
}

-- local function run_fork_cmd_for_packag(package_string)
-- end

local function fork_package(repo_string_node, bufnr)
  local nt = tsq.get_node_text(repo_string_node, bufnr)
  local nt_stripped = string.sub(nt, 2, -2)
  user_ts_utils.ts_single_node_prepend_text(repo_string_node, bufnr, pf.settings.local_prefix)
  local fork_cmd = string.format(
    ":!%s git@github.com:%s.git",
    doom.settings.fork_package_cmd,
    nt_stripped
  )
  print(fork_cmd)
  vim.cmd(fork_cmd)
end

local function make_picker_for_all_packages_in_all_user_modules()

  -- iterate modules > collect packages into all_packages = { { file = "..", node = <user_data> } ... {file,node} }
  --
  -- scandir modules
  -- parse file at path?
  -- get package string nodes
  -- put into table
  -- ...
  --
  -- since I don't to open the files into a buffer, BUT
  -- only parse the file and transform it. Therefore I need
  -- to first read all of the files and then
  -- use vim.treesitter.get_string_parser()
end

local function fork_plugins_picker_cur_buf(config)
  local function pass_entry_to_callback(prompt_buf)
    local state = require("telescope.actions.state")
    local fuzzy_selection = state.get_selected_entry(prompt_bufnr)
    require("telescope.actions").close(prompt_buf)
    config.callback(config.entries_mapped[fuzzy_selection.value], config.bufnr)
  end

  opts = opts or require("telescope.themes").get_cursor()

  require("telescope.pickers").new(opts, {
    prompt_title = "create user module",
    finder = require("telescope.finders").new_table({
      results = config.entries,
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", pass_entry_to_callback)
      map("n", "<CR>", pass_entry_to_callback)
      return true
    end,
  }):find()
end

-- TODO: get query from file `queries` dir.
local function print_query()
  local bufnr, root, q_parsed_2 = user_ts_utils.get_query(
    user_ts_utils.get_query_file("lua", "doom_module_packages")
  )
  local package_string_nodes = user_ts_utils.get_captures(root, bufnr, q_parsed_2, "package_string")
  local picker_config = {
    bufnr = bufnr,
    entries = {},
    entries_mapped = {},
    callback = fork_package,
  }
  for k, v in pairs(package_string_nodes) do
    local nt = tsq.get_node_text(v, bufnr)
    table.insert(picker_config.entries, nt)
    picker_config.entries_mapped[nt] = v
  end
  fork_plugins_picker_cur_buf(picker_config)
end

local function fork_plugin_under_cursor()
  print_query()
end

local function fork_all_packages(include_deps)
  -- if include_deps
end

pf.cmds = {
  { "DoomForkPackageUnderCursor", fork_plugin_under_cursor },
  { "DoomForkPackagePicker", fork_plugin_under_cursor },
  {
    "DoomForkAllPackages",
    function()
      fork_all_packages()
    end,
  },
  {
    "DoomForkAllPackagesInclDeps",
    function()
      fork_all_packages(true)
    end,
  },
}

pf.binds = {}

if require("doom.utils").is_module_enabled("whichkey") then
  table.insert(pf.binds, {
    "<leader>",
    name = "+prefix",
    {
      {
        "v",
        name = "+testing",
        {
          {
            "u",
            [[<cmd>DoomForkPackageUnderCursor<cr>]],
            name = "fork plugin at cursor",
            options = { silent = false },
          },
          {
            "w",
            [[<cmd>DoomForkPackagePicker<cr>]],
            name = "fork plugin by picker",
            options = { silent = false },
          },
        },
      },
    },
  })
end

return pf
