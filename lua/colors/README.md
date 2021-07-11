# Colors

This module contains the embedded colorschemes for Doom Nvim and the utils
module required by those colorschemes.

Actually the embedded colorschemes are the following:

- doom-one (dark and light variant)

## utils

The utils module contains a few utilities for easily port Doom Emacs colorschemes
to Lua colorschemes. These utilities are the following:

- `Lighten` - lighten the provided HEX color in X percentage (5 by default).
- `Darken` - darken the provided HEX color in X percentage (5 by default).
- `Mix` - mix two provided HEX colors in X percentage (0 by default)

## Contributing

### Write colorschemes

If you want to write colorschemes for Doom Nvim you will need to follow some
requirements.

- The colorscheme should be a Doom Emacs colorscheme, see [emacs-doom-themes].
- The colorscheme should be written in pure Lua **without using helpers like lush**,
  you can take a look at [doom-one] source or use it as a template (highly recommended).

### Update embedded colorschemes

If you want to update the embedded colorschemes like [doom-one] you'll need to
copy the doom-one files to the proper locations and change a few lines to match
Doom Nvim structure.

- Changes in `colors/doom-one.lua`:

```lua
--- FROM:
package.loaded['doom-one'] = nil
require('doom-one')

--- TO:
package.loaded['colors.doom-one'] = nil
require('colors.doom-one')
```

- Changes in `doom-one/init.lua`:

```lua
--- FROM:
local utils = require('utils')

--- TO:
local utils = require('colors.utils')
```

[doom-one]: https://github.com/NTBBloodbath/doom-one.nvim
[emacs-doom-themes]: https://github.com/hlissner/emacs-doom-themes
