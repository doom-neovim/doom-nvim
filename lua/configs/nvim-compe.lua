--- nvim-compe configuration
-- https://github.com/hrsh7th/nvim-compe#lua-config
require('compe').setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 2;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        calc = true;
        vsnip = true;
        nvim_lsp = true;
        nvim_lua = true;
        spell = true;
        tags = true;
        snippets_nvim = true;
        treesitter = true;
    };
}
