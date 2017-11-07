#!/bin/bash

. "./lib/assert.sh"
. "./cdpath.sh"

bold=`tput bold`
green=`tput setaf 2`
red=`tput setaf 1`
reset=`tput sgr0`

# Base command
assert "cdpath" "usage: cdpath [-h] [-r] [-l] [-i] [-u] <name> <path>\nSee \"cdpath -h\" for help."
mkdir _test_folder
assert "cdpath _test_folder ."
assert "cat ~/.cdpath | grep _test_folder" ":_test_folder:`pwd`/"
rm -rf _test_folder
assert "cdpath _test_folder ." "No such directory: `pwd`/_test_folder"
assert "cdpath -?" "Unknown option: -?\n\nusage: cdpath [-h] [-r] [-l] [-i] [-u] <name> <path>\nSee \"cdpath -h\" for help."
# -h option
assert "cdpath -h" "cdpath basic usage: \"cdpath <name> <path>\"\n    name    The path's shortcut, called with \"cd\"\n    path    The path to link the name with\n\ncdpath options:\n    -h    Shows help\n    -r    Removes a shortcut from cdpath (e.g. \"cdpath -r <name>\")\n    -l    Lists all shortcuts and their respective paths\n    -i    Installs cdpath (e.g. \"cdpath -i ~/.bashrc\")\n    -u    Uninstalls cdpath (e.g. \"cdpath -u ~/.bashrc\")\n"

# -l option
assert_raises "cdpath -l | grep _test_folder" 0

# -r option
assert "cdpath -r _test_folder" "${bold}Successfully removed \"_test_folder\"${reset}"
assert_raises "cat ~/.cdpath | grep _test_folder" 1
assert "cdpath -r _test_folder" "${red}There's no shortcut named \"_test_folder\"${reset}"

# -u option
assert_raises "ls ~/.cdpath" 0
assert "cdpath -u ~/.bashrc" "Uninstalling cdpath...\nDone."
assert_raises "ls ~/.cdpath" 2

# -i option
assert "cdpath -i ~/.bashrc" "Installing cdpath...\nDone."
assert_raises "ls ~/.cdpath" 0
assert_raises "cat ~/.bashrc | grep \"export CDPATH=\".\$(cat \"\$HOME/.cdpath\" | sed \":a;N;\$!ba;s\/\\n//g\")" 0

assert_end cdpath
