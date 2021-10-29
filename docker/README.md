# Doom Contrib Docker Image

This docker image aids in development by setting up a docker virtual environment and git worktree of doom-nvim to make your changes within.

## How to use

The setup and start process is handled in the `./bootstrap.sh` script.

```
Bootstraps a docker image for contributing changes to doom-nvim

Syntax: ./bootstrap.sh [-b <branc_name>]
options:
-b     Create a new branch for the contribution (default is doom-nvim-contrib)
-h     Shows this help menu
```

## What this script does

1. On first execution it will setup a git worktree of doom-nvim, this means your main config and this copy of the repo will share the same git history.
    - This worktree will be placed in the `docker/doom-nvim-contrib` folder inside of this repository.
    - Because they share history you wont be able to checkout the same branch on both copies of the repository.  Unless specified, a new branch called `doom-nvim-contrib` will be created off the latest version of `develop`.
2. It will setup a new docker image to run this config within (if necessary).
3. It will then start the docker image and enter you into neovim.

## Folders

These are the folders used by this docker image, they will be auto generated when `./bootstrap.sh` is run

`docker/doom-nvim-contrib/` - Git worktree for doom-nvim contributions
`docker/local-share-nvim/` - Stores the data from `~/.local/share/nvim/` 
`docker/workspace/` - Directory to store test files and project that you want to test your changes upon
