## Updating Neovim

Doom-nvim currently requires neovim `^v0.7.x`, check your neovim version by running `nvim -v` in the command line.

## MacOS / Brew

1. Ensure you have [https://brew.sh/](https://brew.sh/) installed.
2. Run `brew install neovim` to install the latest version.

## Ubuntu / apt-get

Ubuntu doesn't always have the latest neovim in its own internal PPA.  You will have to add the neovim ppa to get the latest versions.

1. Ensue you have software-properties-common (allows you to add extra ppa sources): `sudo apt install software-properties-common -y`.
2. Import the stable nim ppa. `sudo add-apt-repository ppa:neovim-ppa/stable -y`.
3. Run update to sync changes `sudo apt-get update`.
4. Install the latest stable neovim: `sudo apt install neovim -y`
