#!/bin/bash
rm local-share-nvim/ local-state-nvim/ -rf
rm -f doom-nvim-contrib/plugin/packer_compiled.lua
echo
echo "Bootstrapping packages"
echo
exec ./start_docker.sh -- --entrypoint='["/usr/bin/nvim","--headless","--cmd","autocmd User PackerComplete quitall"]'
