#!/bin/sh
echo "Executing initial bootstrap/sync"
rm -f local-share-nvim/plugin/packer_compiled.lua
rm -f doom-nvim-contrib/plugin/packer_compiled.lua
rm -rf local-share-nvim/ local-state-nvim/
./start_docker.sh -- --rm --entrypoint='["/usr/bin/nvim","--headless","--cmd","autocmd User PackerComplete quitall","--cmd","autocmd User DoomStarted PackerSync"]'
./start_docker.sh -- --rm --entrypoint='["/usr/bin/nvim","--headless","--cmd","autocmd User PackerComplete quitall","--cmd","autocmd User DoomStarted PackerSync"]'
echo "Testing config"
exec ./start_docker.sh -- --rm --entrypoint='["/usr/bin/nvim","--headless","+qa"]'
