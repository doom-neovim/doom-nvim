local hex2rgb = function(hex)
  hex = hex:gsub("#", "")
  return {
    tonumber("0x" .. hex:sub(1, 2)),
    tonumber("0x" .. hex:sub(3, 4)),
    tonumber("0x" .. hex:sub(5, 6)),
  }
end

--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
local rgbToHsv = function(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then
    s = 0
  else
    s = d / max
  end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
      h = (g - b) / d
      if g < b then
        h = h + 6
      end
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v
end

local statusline = {}

statusline.settings = {}

statusline._safe_get_highlight = function(...)
  for _, hlname in ipairs({ ... }) do
    if vim.fn.hlexists(hlname) == 1 then
      local id = vim.fn.synIDtrans(vim.api.nvim_get_hl_id_by_name(hlname))
      local foreground = vim.fn.synIDattr(id, "fg")
      local background = vim.fn.synIDattr(id, "bg")
      if foreground and foreground:find("^#") then
        return { foreground = foreground, background = background }
      end
    end
  end
  return { foreground = "#000000", background = "#000000" }
end

statusline._generate_colorscheme = function()
  local colors = vim.tbl_map(function(hl)
    return {
      hex = hl,
      rgb = hex2rgb(hl),
    }
  end, {
    statusline._safe_get_highlight("luaTSField", "TSField").foreground,
    statusline._safe_get_highlight("luaTSConditional", "TSConditional").foreground,
    statusline._safe_get_highlight("luaTSFunction", "TSFunction").foreground,
    statusline._safe_get_highlight("luaTSKeywordFunction", "TSKeywordFunction").foreground,
    statusline._safe_get_highlight("luaTSString", "TSString").foreground,
    statusline._safe_get_highlight("luaTSNumber", "TSNumber").foreground,
  })

  local rate_color = function(hsv)
    local averageDist = 0
    local furthestDist = 0
    local numberOfNearbyNodes = 0
    for _, color in ipairs(colors) do
      local dist = math.abs(hsv[1] - color.hsv[1])
      if dist ~= 0 then
        furthestDist = math.max(dist, furthestDist)
        averageDist = averageDist + dist
        if dist < 0.1 then
          numberOfNearbyNodes = numberOfNearbyNodes + 1
        end
      end
    end
    averageDist = averageDist / #colors

    -- Prioritise colours that are far away from others
    local averageDistanceRating = averageDist * 2
    -- Prioritise colours that are the center of clusters
    local proximityRating = numberOfNearbyNodes * 0.2
    -- Prioritise nodes with roughly 0.8 brightness
    local allowedBrightnessRating = (1 - math.abs(0.8 - hsv[3]))
    -- Prioritise nodes with high saturation
    local saturationRating = hsv[2] * 0.3

    local rating = (averageDistanceRating + proximityRating + saturationRating)
      * allowedBrightnessRating
    return rating
  end

  for _, color in ipairs(colors) do
    local h, s, v = rgbToHsv(unpack(color.rgb))
    color.hsv = { h, s, v }
  end
  for _, color in ipairs(colors) do
    color.rating = rate_color(color.hsv)
  end

  table.sort(colors, function(a, b)
    return a.rating > b.rating
  end)

  return unpack(vim.tbl_map(function(color)
    return color.hex
  end, colors))
end

statusline.packages = {
  ["heirline.nvim"] = {
    "rebelot/heirline.nvim",
    commit = "efbf99c48d03f456b19680a46f0e21acd6df5188",
  },
}

statusline.configs = {}
statusline.configs["heirline.nvim"] = function()
  local utils = require("heirline.utils")
  local conditions = require("heirline.conditions")

  local special, special2, special3 = doom.modules.features.statusline._generate_colorscheme()

  local safe_get_highlight = doom.modules.features.statusline._safe_get_highlight
  local colors = {
    normal = safe_get_highlight("Normal").foreground,
    insert = safe_get_highlight("Insert", "String", "MoreMsg").foreground,
    replace = safe_get_highlight("Replace", "Number", "Type").foreground,
    visual = safe_get_highlight("Visual", "Special", "Boolean", "Constant").foreground,
    command = safe_get_highlight("Command", "Identifier", "Normal").foreground,

    background = safe_get_highlight("StatusLine").background,
    base = safe_get_highlight("StatusLine").foreground,
    dim = safe_get_highlight("StatusLineNC", "Comment").foreground,
    special = special,
    special2 = special2,
    special3 = special3,

    diag = {
      warn = safe_get_highlight("DiagnosticWarn").foreground,
      error = safe_get_highlight("DiagnosticError").foreground,
      hint = safe_get_highlight("DiagnosticHint").foreground,
      info = safe_get_highlight("DiagnosticInfo").foreground,
    },
    git = {
      del = safe_get_highlight("diffRemoved", "DiffAdded").foreground,
      add = safe_get_highlight("diffAdded", "DiffAdded").foreground,
      change = safe_get_highlight("diffChanged", "DiffChange", "DiffAdded").foreground,
    },
  }

  local Notch = {
    {
      provider = function()
        return "█"
      end,
      hl = { fg = colors.special2 },
    },
  }

  local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
      mode_colors = {
        n = colors.normal,
        i = colors.insert,
        v = colors.visual,
        V = colors.visual,
        ["\22"] = colors.visual,
        c = colors.command,
        s = colors.purple,
        S = colors.purple,
        ["\19"] = colors.purple,
        R = colors.replace,
        r = colors.replace,
        ["!"] = colors.red,
        t = colors.red,
      },
    },
    provider = function()
      return "   "
    end,
    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
      local mode = self.mode:sub(1, 1) -- get only the first mode character
      return { fg = self.mode_colors[mode], bold = true }
    end,
  }

  --[[
  --  FILE BLOCK
  --]]
  local FileBlock = {
    init = function(self)
      self.filename = vim.fn.expand("%:t")
      self.filepath = vim.fn.expand("%:p")
    end,
  }

  local FileSize = {
    provider = function(self)
      -- Return early if no file size
      local fsize = vim.fn.getfsize(self.filepath)
      if fsize <= 0 then
        return ""
      end

      local suffix = { "b", "k", "M", "G", "T", "P", "E" }
      local i = 1
      while fsize > 1024 do
        fsize = fsize / 1024
        i = i + 1
      end
      return string.format(" %.1f%s ", fsize, suffix[i])
    end,
    hl = { fg = colors.dim },
  }

  local FileIcon = {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
        filename,
        extension,
        { default = true }
      )
    end,
    provider = function(self)
      return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  }

  local FileName = {
    provider = function(self)
      -- first, trim the pattern relative to the current directory. For other
      -- options, see :h filename-modifers
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        return "[No Name] "
      end
      -- now, if the filename would occupy more than 1/4th of the available
      -- space, we trim the file path to its initials
      -- See Flexible Components section below for dynamic truncation
      filename = vim.fn.pathshorten(filename)
      return filename .. " "
    end,
    hl = { fg = colors.special },
  }

  local FileFlags = {
    {
      provider = function()
        if vim.bo.modified then
          return " "
        end
      end,
      hl = { fg = colors.green },
    },
    {
      provider = function()
        if not vim.bo.modifiable or vim.bo.readonly then
          return " "
        end
      end,
      hl = { fg = colors.orange },
    },
  }

  local FileNameModifer = {
    hl = function()
      if vim.bo.modified then
        -- use `force` because we need to override the child's hl foreground
        return { fg = colors.cyan, bold = true, force = true }
      end
    end,
  }

  -- let's add the children to our FileBlock component
  FileBlock = utils.insert(
    FileBlock,
    FileSize,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    unpack(FileFlags) -- A small optimisation, since their parent does nothing
  )

  local LSPActive = {
    condition = conditions.lsp_attached,

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider = function()
      local servers = vim.lsp.buf_get_clients(0)
      if #servers == 0 then
        return string.format(" %s ", vim.bo.filetype)
      elseif #servers == 1 then
        return " LSP "
      else
        return (" LSP(%s) "):format(#servers)
      end
    end,
    hl = { fg = colors.dim },
  }

  local FileEncoding = {
    hl = { fg = colors.dim },
    provider = function()
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return enc:upper() .. " "
    end,
  }

  --[[
  --  GIT BLOCK
  --]]
  local GitBlock = {
    condition = function()
      local has_gitsigns_module = doom.features.gitsigns ~= nil
      local is_git_repo = conditions.is_git_repo()
      local has_status_dict = vim.b.gitsigns_status_dict ~= nil
      return has_gitsigns_module and is_git_repo and has_status_dict
    end,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
    end,

    {
      {
        hl = { fg = colors.special2 },
        provider = function()
          return "  "
        end,
      },
      {
        hl = { fg = colors.special2 },
        provider = function(self)
          return self.status_dict.head .. " "
        end,
      },
    },

    {
      {
        hl = { fg = colors.git.add },
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ("  " .. count)
        end,
      },
      -- Changed component
      {
        hl = { fg = colors.git.change },
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ("  " .. count)
        end,
      },
      -- Deleted component
      {
        hl = { fg = colors.git.del },
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ("  " .. count .. " ")
        end,
      },
    },
  }

  local Ruler = {
    {
      hl = { fg = colors.dim },
      provider = " %P ",
    },
    {
      provider = "%3l:%-2c ",
    },
  }

  local heirline_config = {
    hl = { bg = colors.background },
    { Notch },
    { ViMode },
    { FileBlock },
    { FileEncoding },
    { provider = " %= " },
    { LSPActive },
    { GitBlock },
    { Ruler },
    { Notch },
  }

  require("heirline").setup(heirline_config)
end

statusline.try_refresh = function ()
  xpcall(doom.modules.features.statusline.configs["heirline.nvim"], debug.traceback)
end

statusline.autocmds = {
  {
    "ColorScheme",
    "*",
    function()
      vim.defer_fn(function()
        statusline.try_refresh()
      end, 1)
    end,
  },
  -- Sometimes the colorscheme doesn't load on the first try
  {
    "VimEnter",
    "*",
    function()
      vim.defer_fn(function()
        statusline.try_refresh()
      end, 100)
    end,
    once = true,
  },
}

return statusline
