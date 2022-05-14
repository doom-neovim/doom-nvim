local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")

local project_tasks = {
  {
    name = "paper_airplane",
    tasks = {
      {
        name = "buy paper",
        status = "urgent",
        context = "shop",
      },
      {
        name = "read the airplane book",
        status = "cancelled",
      },
      {
        name = "watch the video",
        status = "undone",
        context = "home",
      },
    },
  },
  {
    name = "neovim_config",
    tasks = {
      {
        name = "clean up plugins",
        status = "undone",
        context = "today",
      },
      {
        name = "install the best plugin (neorg)",
        status = "done",
        context = "today",
      },
      {
        name = "write custom telescope picker",
        status = "pending",
      },
    },
  },

  {
    name = "new_plugin",
    tasks = {}, -- got no ideas so far
  },
}

local function pick_tasks(project)
  for _, project_tbl in ipairs(project_tasks) do
    if project_tbl.name == project.name then
      print(vim.inspect(project_tbl))
    end
  end
end

local function reloader()
  RELOAD("plenary")
  RELOAD("telescope")
  RELOAD("ignis.modules.files.telescope")
  set_options()
end

local function pick_project_tasks(opts) -- always expose options
  reloader()
  opts = opts or {} -- if the user didn't specify options
  pickers.new(opts, {
    finder = finders.new_table({
      results = project_tasks,
      entry_maker = function(project)
        local function format_name(name)
          name = name:gsub("_", " ")
          local first_upper = name:sub(1, 1):upper()
          return first_upper .. name:sub(2, -1)
        end

        local formatted = format_name(project.name)
        local displayer = entry_display.create({
          separator = ": ",
          items = {
            { width = 30 },
            { remaining = true },
          },
        })
        local function make_display(entry)
          return displayer({
            {
              formatted,
              function()
                if #entry.tasks == 0 then
                  return { { { 0, 30 }, "Comment" } }
                else
                  return { { { 0, 30 }, "String" } }
                end
              end,
            },
            { tostring(#entry.tasks) .. " Tasks", "Special" },
          })
        end

        return {
          value = project,
          display = function(tbl)
            return make_display(tbl.value) -- the value field is the original entry
          end,
          ordinal = formatted,
        }
      end,
    }),

    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function()
        local entry = state.get_selected_entry()
        actions.close(prompt_bufnr)

        pick_tasks(entry.value)
      end)
      return true
    end,
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, status)
        local task_lines = {}
        for _, project in ipairs(project_tasks) do
          if project == entry.value then
            for _, task in ipairs(project.tasks) do
              table.insert(task_lines, task.name)
            end
          end
        end
        if #task_lines ~= 0 then
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, task_lines)
        else
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, { "No Tasks" })
        end
      end,
    }),
  }):find()
end
