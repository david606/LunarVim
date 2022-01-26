#!/usr/bin/env bash

declare -r LUNARVIM_DIR="${LUNARVIM_DIR:-"$HOME/.local/share/lunarvim"}"
declare -r FTPLUGIN="${FTPLUGIN:-"$LUNARVIM_DIR/site/after/ftplugin"}"

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

# copy popular language templates to ftplugin
function copy_example_to_ftplugin(){
  msg "Copying language template to ftplugin ..."
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/java.example.lua" "$FTPLUGIN/java.lua"
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/go.example.lua" "$FTPLUGIN/go.lua"
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/python.example.lua" "$FTPLUGIN/python.lua"
}

function main(){
  copy_example_to_ftplugin
}

main
