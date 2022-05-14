  local meh = {}

  -- AUTO RELOAD PLUGIN DURING DEVEPMENT
  table.insert(meh, {
    "BufEnter,BufReadPost",
    "*.lua", -- specify dir where you have your plugins locally?
    function()
      local scan_dir = require("plenary.scandir").scan_dir

      -- 1. get lua modules
      -- 2. compare names to repo
      -- 3. if has telescope/_extensions (todo..)
      -- 4. compare tele ext names to repo name.
      -- 5. filter duplicates on scan_dir after having removed .lua extension

      local function get_modules_under_lua_dir(lua_dir, repo_name)
        local t = {
          repo_match = nil,
          has_telescope_dir = false,
        }
        -- scan lua dir
        local modules_under_lua = scan_dir(
          lua_dir,
          { search_pattern = ".", depth = 1, hidden = false, add_dirs = true } -- only_dirs
        )

        -- filter only filename
        for idx, mpath in ipairs(modules_under_lua) do
          mpath = string.match(
            mpath,
            string.format("%s%s(.*)", utils.escape_str(lua_dir), system.sep)
          )
          modules_under_lua[idx] = mpath
        end

        modules_under_lua = vim.fn.uniq(modules_under_lua)

        if #modules_under_lua == 1 then
            t.repo_match = modules_under_lua[1]
        else
          for _, lua_entry in ipairs(modules_under_lua) do
            if lua_entry == "telescope" then
              t.has_telescope_dir = true
            else
              local match = string.match(
                repo_name,
                string.format("%s", utils.escape_str(lua_entry))
              )
              if match ~= nil then
                t.repo_match = lua_entry
              end
            end
          end
        end

        if t.repo_match == nil and t.has_telescope_dir then
          t.repo_match = "telescope"
        end

        return t
      end

      local function get_telescope_extension_names(t, lua_dir)
        local modules_under_tele_ext = {}
        local tele_ext_dir = lua_dir .. "/telescope/_extensions"
        if t.repo_match == "telescope" or t.has_telescope_dir then
          modules_under_tele_ext = scan_dir(
            tele_ext_dir,
            {
              search_pattern = ".",
              depth = 1,
              hidden = false,
              add_dirs = true,
            } -- only_dirs
          )
        end
        for idx, mpath in ipairs(modules_under_tele_ext) do
          mpath = string.match(
            mpath,
            string.format("%s%s(.*)", utils.escape_str(tele_ext_dir), system.sep)
          )
          modules_under_tele_ext[idx] = mpath:gsub("%.lua", "") -- strip .lua
        end

        t["telescope_extensions"] = vim.fn.uniq(modules_under_tele_ext) -- strip dupl
        return t
      end

      local cwd = vim.fn.getcwd()
      local cwd_tail = nil -- the cwd dir name
      local buf_fname = vim.api.nvim_buf_get_name(0)
      local cwd_lua_subdir = string.format("%s%slua", cwd, system.sep)
      local cwd_repo_name = string.match(cwd, "([%w%-%.%_]*)$") -- cwd get tail | can this be done with plenary.path?
      local t_cwd = get_modules_under_lua_dir(cwd_lua_subdir, cwd_repo_name)
      local is_telescope_ext_only = t_cwd.repo_match == "telescope" and t_cwd.has_telescope_dir

      t_cwd = get_telescope_extension_names(t_cwd, cwd_lua_subdir)

      -- -- PRINT
      -- print(
      --   "CWD:",
      --   cwd_repo_name, -- cwd repo dir name
      --   ", LUA MATCH:",
      --   t_cwd.repo_match, -- match in the repo dir name
      --   ", t: ",
      --   t_cwd.has_telescope_dir, -- tele dir exists under `lua/`
      --   ", isext: ",
      --   is_telescope_ext_only -- there is only tele ext under `lua/`
      -- )

      -- IF DOOM THEN WE SHOULD NOT RELOAD ANY MODULES VIA THIS METHOD
      if t_cwd.repo_match == "doom" then
        return
      end

      -- TODO: PREPARE CONDITIONAL RELOAD PATTERNS

      -- 1. if repo_match == tele AND #ext > 0    ext
      -- 2. if repo_match == tele AND #ext == 0   telescope.nvim itself
      -- 3. if repo_match == other AND #ext > 0   plugin + ext
      -- 4. if repo_match == other AND #ext = 0   plugin only

      -- if regular module then
      --  reload `<name>`
      -- end

      -- if telescope_match then
      -- reload `telescope._extensions.<`
      -- end

      -- -- A. PERFORM THE RELOADING
      -- local matcher
      -- if true then
      --   matcher = function(pack)
      --     return string.find(pack, t_cwd.repo_match, 1, true)
      --   end
      -- else
      --   matcher = function(pack)
      --     return string.find(pack, "^" .. t_cwd.repo_match)
      --   end
      -- end
      -- for pack, _ in pairs(package.loaded) do
      --   if matcher(pack) then
      --     -- NOTE: print package matches here
      --     print("!! match: ", pack)
      --     -- package.loaded[pack] = nil
      --     -- if luacache then
      --     --   luacache[pack] = nil
      --     -- end
      --   end
      -- end

      -- OR USE PLENARY

      -- B. reload module name here
      -- you can pass a `pattern` to plenary
      require("plenary.reload").reload_module(t_cwd.repo_match)
      if t_cwd.has_telescope_dir then
        require("plenary.reload").reload_module("telescope")
      end

      local log_str = string.format(
        [[%s
--------
CWD_DIR:    %s
MATCH:    %s
---------------------------------------
      ]],
        "RELOADER | AUTOCMD : `reload module on save`",
        cwd_tail,
        -- buf_fname,
        -- sp,
        -- vim.inspect(modules_under_lua),
        cwd_tail_lua_match
      )

      log.info(log_str)
    end,
  })


