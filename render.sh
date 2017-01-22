#!/bin/bash
# ZSH
shell="~/.zshrc" \
expstr="export CDPATH=\".\`cat \"\$HOME/.cdpath\" | sed ':a;N;\$!ba;s/\\\n//g'\`\"" \
grepstr="export CDPATH=\".\`cat \"\$HOME/.cdpath\" | sed ':a;N;\$!ba;s/\\\n//g'\`\"" \
paths='`echo ${paths//\"/}`' \
choice='$choice:l' \
./lib/mo cdpath.mo.sh > ../cdpath.zsh.sh
# BASH
shell="~/.bashrc" \
expstr='export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;$!ba;s/\n//g"`"' \
grepstr='export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;\$!ba;s\/\\n//g"`"' \
paths='$paths' \
choice='${choice,,}' \
./lib/mo cdpath.mo.sh > ../cdpath.bash.sh
