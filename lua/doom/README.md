# Doom

This is the entry point module for Doom Nvim. Herein lies the core of Doom
divided into three different sub-modules.

- [core](./core/README.md) - The Doom core, herein lies the entire Doom core,
    e.g. configurations.
- [extras](./extras/README.md) - Doom extras, herein lies the Doom keybindings,
    autocommands, etc.
- [modules](./modules/README.md) - The Doom modules, herein lies the Doom plugins
    and their configurations.
- [utils](./utils/README.md) - The Doom utilities, herein lies the Doom utility
    functions.

## Note: dev w/ctags

1. ctags for jumping to func defs
    https://github.com/universal-ctags/ctags
2. In doom-nvim root run `ctags --recurse`
3. Put cursos on top of require file name
4. Press `<leader>nt`
5. This will jump to the definition of whatever is under cursor.


