# Compiler

This plugin aims to take care of your projects by helping you to:

- Compile your entire project.
- Compiling and running your project.

## Currently supported languages

- Rust
- Golang

> **NOTE**: Do you want to give support for other languages? Feel free to open
> a pull request!

## Keybindings

- Compile
  - `SPC - c - b`
- Compile and run
  - `SPC - c - c`

## FAQ

- Why we are using a toggleterm `exec_command` function?

That's because of if we use a custom terminal like in the runner REPL then we
will find an issue:

The terminal closes when the process ends so that's it, you will not see a
correct output for compilation processes or even while running the code. That's
why we are spawning a terminal and then executing the commands for building and
running.
