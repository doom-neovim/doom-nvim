--- @class async
local async = {}

--- Safely close child processes
--- @param handle uv_pipe_t
local function safe_close(handle)
  if handle and not handle:is_closing() then
    handle:close()
  end
end

--- Create a new async process
--- @param job_opts table The async job options
--- @return table
function async:new(job_opts)
  job_opts = job_opts or {}
  for opt, val in pairs(job_opts) do
    self[opt] = val
  end
  setmetatable(job_opts, self)
  self.__index = self

  return job_opts
end

--- Set the async job options
--- @return table
function async.options()
  local options = {}
  local args = vim.split(async.cmd, " ")

  async.stdin = vim.loop.new_pipe(false)
  async.stdout = vim.loop.new_pipe(false)
  async.stderr = vim.loop.new_pipe(false)

  -- Get the async job command, e.g. 'git'
  options.command = table.remove(args, 1)
  options.args = args
  options.stdio = { async.stdin, async.stdout, async.stderr }

  if async.cwd then
    options.cwd = async.cwd
  end

  if async.env then
    options.env = async.env
  end

  if async.detach then
    options.detach = async.detach
  end

  return options
end

--- Send data to stdin
--- @param data string
async.send = function(data)
  async.stdin:write(data)
  async.stdin:shutdown()
end

--- Shutdown stdio in async jobs
--- @param code number The exit code
--- @param signal number The exit signal
async.shutdown = function(code, signal)
  if async.on_exit then
    async.on_exit(code, signal)
  end
  if async.on_stdout then
    async.stdout:read_stop()
  end
  if async.on_stderr then
    async.stderr:read_stop()
  end
  async.stop()
end

--- Start a new async job
async.start = function()
  local opts = async.options()
  local cmd = opts.command
  opts.command = nil

  async.handle = vim.loop.spawn(cmd, opts, async.shutdown)
  if async.on_stdout then
    vim.loop.read_start(async.stdout, vim.schedule_wrap(async.on_stdout))
  end
  if async.on_stderr then
    vim.loop.read_start(async.stderr, async.on_stderr)
  end
end

--- Stop an async job
async.stop = function()
  safe_close(async.stdin)
  safe_close(async.stdout)
  safe_close(async.stderr)
  safe_close(async.handle)
end

return async
