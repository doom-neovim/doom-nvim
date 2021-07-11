# Runner

This plugin aims to take care of your interpreted code by helping you to:

- Opening a REPL for fast testing.
- Running the current file.

## Currently supported languages

- V
- Lua
- Ruby
- Python

> **NOTE**: Do you want to give support for other languages? Feel free to open
> a pull request!

## Keybindings

- REPL
  - `SPC - c - i`
- Run the current file
  - `SPC - c - r`

## FAQ

- Why we are using a toggleterm `exec_command` function for running the file?

That's because of if we use a custom terminal like in the runner REPL then we
will find an issue:

The terminal closes when the process ends so that's it, you will not see a
correct output while running the code. That's why we are spawning a terminal
and then executing the commands for running.
