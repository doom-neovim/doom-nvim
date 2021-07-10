# Doom Modules

Here lies all the built-in modules for Doom Nvim. But what are these modules?

All the submodules here are Doom plugins, that is, they are plugins made in
Doom and for Doom that you will find only in Doom _or we hope so_.

## List of plugins

- runner
  - A built-in function for pressing a few keybinds and executing a REPL for
    the current filetype, inspired by SpaceVim one. e.g. if you are editing a
    Python file then `SPC - c - i` will open a terminal window with Python REPL
    _obviously_. Or if you want to run the current file then you can press
    `SPC - c - r`.
- compiler
  - A built-in function for compiling _and running (optionally)_ your projects.
    By example, for compiling and running your Rust program you will only need
    to press `SPC - c - c` and Doom will take care of your rusty code.
    Otherwise if you only want to compile then you can press `SPC - c - b`.

## FAQ

- Why are we using toggleterm for the runner and the compiler plugins?

That's because toggleterm is a pretty nice plugin that wraps the existing
Neovim terminal integration (`term://`) feature and there is no need to
reinvent the wheel for introducing unneeded complexity in the doom codebase.

> **NOTE:** you can find more information about each plugin in the respective
> plugin directory.
