# Frequently Asked Questions

## General

### What type of vimmer is Doom Nvim intended for?

Doom Nvim is intended for all types of Vimmers who want a stable and efficient
development environment without spending a lot of time setting everything up.

### Why does Doom Nvim only support Neovim 0.5+?

Doom Nvim doesn't support Neovim versions lower than the current stable (0.5)
due big plugin incompatibilities and performance differences, which would make
the experience not worth it.

### How to version control Doom Nvim?

Doom Nvim makes use of an internal variable called `doom_configs_root` that points
to `/home/user/.config/doom-nvim` path by default. This allows you to move your
configuration files to this path so you can version control your doom setup too.
