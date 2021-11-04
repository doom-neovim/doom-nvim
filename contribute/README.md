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

The script will start an instance of neovim that uses `./contribute/doom-nvim-contrib/` for configuration.  
You will then be able to start making changes within `doom-nvim-contrib` without breaking your existing config.

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

## Pinned Dependencies `./update_dependencies.sh`

This script parses the `lua/doom/modules/init.lua` file and pins each plugin to the latest commit in the default branch.  
We should update these dependencies with each release of doom-nvim, and test everything working together to ensure a stable experience for users.
Pinned/frozen dependencies can be disabled using the `freeze_dependencies` configuration option in `doom_config.lua`.

### How to use

Run the following command in the root of the neovim folder.
```bash
cd contribute && ./update_dependencies.sh`
```

### Issues
- The `commit = pin_commit(...)` line must be immediately after the package name
- It does not work if the dependency also has the `branch = '...'` option.  These will have to be updated manually.
- It does not work if there is custom logic for determining pinned commits (such as depending on neovim version).  These will have to be updated manually.
- Github API ratelimits requests, you can specify a GITHUB_API_KEY environment variable (docs)[https://docs.github.com/en/developers/apps/building-oauth-apps], or you can use a VPN to change IP addresses.
