# Frequently Asked Questions

## General

### What type of vimmer is Doom Nvim intended for?

Doom Nvim is intended for all types of Vimmer who want a stable and efficient
development environment without spending a lot of time setting everything up.

### Why does Doom Nvim only support Neovim 0.5+?

Doom Nvim doesn't support Neovim versions lower than the current stable (0.5) due to:

- some features would be lost
- Not all Lua plugins have good alternatives in Vimscript, so the experience
  would not be the same
- performance would not be the same as Lua cannot be used

### How to version control Doom Nvim?

Doom Nvim makes use of an internal variable called `doom_configs_root` that points
to `/home/user/.config/doom-nvim` path by default. This allows you to move your
configuration files to this path so you can version control your doom setup too.

> **NOTE**: In case that you're using cheovim (with `/home/user/.config/doom-nvim`
> as your Doom Nvim path) then you will need to change this variable value manually
> by tweaking [this](../lua/doom/core/system/init.lua) file.

After changing your configurations path you will surely want to remove your
`~/.config/nvim/plugin/packer_compiled.lua` and running `:PackerCompile` again.

Also you will need to create a symlink from your new path to the old one for
avoiding issues when updating Doom Nvim. Here is a snippet for this task.

```sh
# Change this variable path if you have installed Doom Nvim in other place
DOOM_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
# Change this variable path if you have changed the Doom Nvim doom_configs_root variable
DOOM_CONFIG_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/doom-nvim"

# Let's iterate over the configurations path directory files and create a symlink for them
for _config_file in $(ls "$DOOM_CONFIG_ROOT"); do
    ln -s "${DOOM_CONFIG_ROOT}/$_config_file" "${DOOM_ROOT}/$_config_file"
done
```
