#!/bin/bash

# Generate modules documentation
find ../lua/doom/modules/ -type f -name init.lua -exec nvim {} -c "GenerateMarkdownDocCurrentFile" -c "q" \;

