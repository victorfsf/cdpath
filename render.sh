#!/bin/bash
# ZSH
shell="\$HOME/.zshrc" \
expstr=\''export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;$ba;s/\\n//g"`"'\' \
grepstr=\''export CDPATH'\' \
choice='$choice:l' \
./lib/mo cdpath.mo.sh > cdpath/cdpath.zsh.sh
# BASH
shell="\$HOME/.bashrc" \
expstr=\''export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;$!ba;s/\n//g"`"'\' \
grepstr=\''export CDPATH'\' \
choice='${choice,,}' \
./lib/mo cdpath.mo.sh > cdpath/cdpath.bash.sh
