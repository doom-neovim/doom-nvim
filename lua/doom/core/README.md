# Core

Herein lies the core of Doom. In other words, the modules needed for Doom to
be Doom.

Those modules are the following:

- config - Doom configurations, handles `doom-nvim/*.lua` files.
  - init - `config.lua` handler, initializes the `doom` global.
  - modules - `modules.lua` handler.
- functions - Doom core functions, e.g. `create_report`.
- system - Doom system detection utilities.
- ui - Doom UI settings.
- netrw - Optional netrw configs.
