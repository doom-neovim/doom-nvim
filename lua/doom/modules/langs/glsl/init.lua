local glsl = {}

glsl.settings = {
  --- Disables auto installing the treesitter
  --- @type boolean
  disable_treesitter = false,
  --- Treesitter grammars to install
  --- @type string|string[]
  treesitter_grammars = "glsl",

  -- --- Disables default LSP config
  -- --- @type boolean
  -- disable_lsp = false,
  -- --- Name of the language server
  -- --- @type string
  -- lsp_name = "tsserver",

  --- Disables null-ls diagnostic sources
  --- @type boolean
  disable_diagnostics = false,
  --- WARN: No package.  Mason.nvim package to auto install the diagnostics provider from
  --- @type nil
  diagnostics_package = nil,
  --- String to access the null_ls diagnositcs provider
  --- @type string
  diagnostics_provider = "builtins.diagnostics.glslc",
  --- Function to configure null-ls diagnostics
  --- @type function|nil
  diagnostics_config = function(glslc)
    glslc.with({
      extra_args = { "--target-env=opengl" }, -- use opengl instead of vulkan1.0
    })
  end,
}

local langs_utils = require("doom.modules.langs.utils")
glsl.autocmds = {
  {
    "FileType",
    "glsl",
    langs_utils.wrap_language_setup("glsl", function()
      -- if not glsl.settings.disable_lsp then
      --   langs_utils.use_lsp_mason(glsl.settings.lsp_name)
      -- end

      if not glsl.settings.disable_treesitter then
        langs_utils.use_tree_sitter(glsl.settings.treesitter_grammars)
      end

      if not glsl.settings.disable_diagnostics then
        langs_utils.use_null_ls(
          glsl.settings.diagnostics_package,
          glsl.settings.diagnostics_provider,
          glsl.settings.diagnostics_config
        )
      end
    end),
    once = true,
  },
  -- TODO: Refactor to use filetype.lua or filetype.vim
  {
    "BufWinEnter",
    "*.glsl,*.frag,*.vert,*.fs,*.vs",
    function()
      vim.bo.filetype = "glsl"
    end,
  },
}

return glsl
