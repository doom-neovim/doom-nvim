return function()
  local fmt = string.format

  require("format").setup({
    ["*"] = {
      -- remove trailing whitespaces
      {
        cmd = {
          "sed -i 's/[ \t]*$//'",
        },
      },
    },
    vim = {
      {
        cmd = {
          function(file)
            return fmt("stylua --config-path ~/.config/stylua/stylua.toml %s", file)
          end,
        },
        start_pattern = "^lua << EOF$",
        end_pattern = "^EOF$",
      },
    },
    vimwiki = {
      {
        cmd = { "prettier -w --parser babel" },
        start_pattern = "^{{{javascript$",
        end_pattern = "^}}}$",
      },
    },
    lua = {
      {
        cmd = {
          function(file)
            return fmt("stylua --config-path ~/.config/stylua/stylua.toml %s", file)
          end,
        },
      },
    },
    python = {
      {
        cmd = {
          function(file)
            return fmt("yapf -i %s", file)
          end,
        },
      },
    },
    go = {
      {
        cmd = {
          "gofmt -w",
          "goimports -w",
        },
        tempfile_postfix = ".tmp",
      },
    },
    javascript = {
      {
        cmd = {
          "prettier -w",
          "./node_modules/.bin/eslint --fix",
        },
      },
    },
    typescript = {
      {
        cmd = { "prettier -w --parser typescript" },
      },
    },
    html = {
      {
        cmd = { "prettier -w --parser html" },
      },
    },
    markdown = {
      {
        cmd = { "prettier -w --parser markdown" },
      },
      {
        cmd = {
          "yapf -i",
        },
        start_pattern = "^```python$",
        end_pattern = "^```$",
        target = "current",
      },
    },
    css = {
      {
        cmd = { "prettier -w --parser css" },
      },
    },
    scss = {
      {
        cmd = { "prettier -w --parser scss" },
      },
    },
    json = {
      {
        cmd = { "prettier -w --parser json" },
      },
    },
    toml = {
      {
        cmd = { "prettier -w --parser toml" },
      },
    },
    yaml = {
      {
        cmd = { "prettier -w --parser yaml" },
      },
    },
  })
end
