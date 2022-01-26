#!/usr/bin/env bash

# Declare support dir
declare -r DEBUG_BASE_DIR=${BASE_DIR:-"$HOME/.config"}
declare -r SUPPORT_DEBUG_HOME=${SUPPORT_DEBUG_HOME:-"$DEBUG_BASE_DIR/lunarvim-debug-support"}
readonly DEBUG_BASE_DIR SUPPORT_DEBUG_HOME

# Declare debug environment remote address
declare -r JAVA_DEBUG_REMOTE=${JAVA_DEBUG_REMOTE:-"https://github.com/microsoft/java-debug.git"}
declare -r JAVA_VSCODE_TEST_REMOTE=${JAVA_VSCODE_TEST_REMOTE:-"https://github.com/microsoft/vscode-java-test.git"}
declare -r GO_VSOCDE_REMOTE=${GO_VSOCDE_REMOTE:-"https://github.com/golang/vscode-go.git"}

declare -r LUNARVIM_DIR="${LUNARVIM_DIR:-"$HOME/.local/share/lunarvim"}"
declare -r FTPLUGIN="${FTPLUGIN:-"$LUNARVIM_DIR/site/after/ftplugin"}"
# clone repository to specify directory

declare TARGET_DIR=""

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function check_dir_exists(){
  if [ ! -e "$1" ] || [ ! -d "$1" ]; then
    msg "$1 is not exists, now creating..."
    mkdir -p "$1" 
  fi
}

function get_remote_dir_name(){
  dir=${1##*/} 
  TARGET_DIR=${dir%.*}
}

function clone_repository(){
  # change TARGET_DIR value
  get_remote_dir_name "$1"

  msg "Now cloning $TARGET_DIR ..."
  
  if ! git clone "$1" "$SUPPORT_DEBUG_HOME/$TARGET_DIR"; then
    msg "Faild to clone repository. Installation failed."
    exit 1
  fi
}

# $1 git address
# $2 command type
# $3 npm run named srcipt
function install_debug_env(){
  
  # change TARGET_DIR value
  get_remote_dir_name $1

  if [ ! -d $SUPPORT_DEBUG_HOME/$TARGET_DIR ]; then
    msg "$TARGET_DIR repository has not cloned to the local" 
    clone_repository $1
  fi

  msg "Now installing $TARGET_DIR ..."
  cd $SUPPORT_DEBUG_HOME/$TARGET_DIR
  
  if [ "$2" == "maven" ]; then
    mvn clean install 
  elif [ "$2" == "npm" ]; then
    npm install
    npm run $3 
  fi
}

# copy popular language templates to ftplugin
function copy_example_to_ftplugin(){
  msg "Copying language template to ftplugin ..."
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/java.example.lua" "$FTPLUGIN/java.lua"
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/go.example.lua" "$FTPLUGIN/go.lua"
  cp "$LUNARVIM_DIR/lvim/utils/installer/ftplugin-example/python.example.lua" "$FTPLUGIN/python.lua"
}

function install_python_debug_env(){
  msg "Now installing debugpy ..."

  cd $SUPPORT_DEBUG_HOME
  if [ ! -d $SUPPORT_DEBUG_HOME/virtualenvs ]; then
    mkdir virtualenvs
  fi

  cd $SUPPORT_DEBUG_HOME/virtualenvs
  python -m venv debugpy
  debugpy/bin/python -m pip install debugpy
  debugpy/bin/python -m pip install --upgrade pip
}

function main(){ 
  check_dir_exists $SUPPORT_DEBUG_HOME
  
  # install java debug
  install_debug_env $JAVA_DEBUG_REMOTE maven
  install_debug_env $JAVA_VSCODE_TEST_REMOTE npm build-plugin

  # install go debug
  msg "Now installing go-delve ..."
  go install github.com/go-delve/delve/cmd/dlv@latest
  install_debug_env $GO_VSOCDE_REMOTE npm compile

  # install python debug
  install_python_debug_env

  # copy popular language templates to ftplugin
  copy_example_to_ftplugin
}

main
