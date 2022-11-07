#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Generate modules documentation
find "$SCRIPT_DIR/../lua/doom/modules" -type f -name init.lua -exec nvim {} -c "GenerateDocCurrentFile" -c "q" \;

