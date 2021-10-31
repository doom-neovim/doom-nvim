# Contributing Tools for Doom Neovim

This directory stores various tools and automations to help contributors or develpers of doom-nvim. 

## Doom Contrib Docker Image `./start_docker.sh`

This docker image aids in development by setting up a docker virtual environment and git worktree of doom-nvim to make your changes within.

### How to use

The setup and start process is handled in the `./start_docker.sh` script.

```
Bootstraps a docker image for contributing changes to doom-nvim

Syntax: ./start_docker.sh [-b <branch_name>]
options:
-b     Create a new branch for the contribution (default is doom-nvim-contrib)
-h     Shows this help menu
```

### What this script does

1. On first execution it will setup a git worktree of doom-nvim, this means your main config and this copy of the repo will share the same git history.
    - This worktree will be placed in the `contribute/doom-nvim-contrib` folder inside of this repository.
    - Because they share history you wont be able to checkout the same branch on both copies of the repository.  Unless specified, a new branch called `doom-nvim-contrib` will be created off the latest version of `develop`.
2. It will setup a new docker image to run this config within (if necessary).
3. It will then start the docker image and enter you into neovim.

### Generated Folders

These are the folders used by this docker image, they will be auto generated when `./start_docker.sh` is run

`contribute/doom-nvim-contrib/` - Git worktree for doom-nvim contributions
`contribute/local-share-nvim/` - Stores the data from `~/.local/share/nvim/` 
`contribute/workspace/` - Directory to store test files and project that you want to test your changes upon
