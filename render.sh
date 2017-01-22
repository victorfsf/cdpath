#!/bin/bash

echo 'Rendering the ZSH Template...'
shell="~/.zshrc" \
expstr="export CDPATH=\".\`cat \"\$HOME/.cdpath\" | sed ':a;N;\$!ba;s/\\\n//g'\`\"" \
grepstr="export CDPATH=\".\`cat \"\$HOME/.cdpath\" | sed ':a;N;\$!ba;s/\\\n//g'\`\"" \
paths='`echo ${paths//\"/}`' \
choice='$choice:l' \
./lib/mo cdpath.mo > ../cdpath.zsh.sh


echo 'Rendering the BASH Template...'
shell="~/.bashrc" \
expstr='export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;$!ba;s/\n//g"`"' \
grepstr='export CDPATH=".`cat "$HOME/.cdpath" | sed ":a;N;\$!ba;s\/\\n//g"`"' \
paths='$paths' \
choice='${choice,,}' \
./lib/mo cdpath.mo > ../cdpath.bash.sh

echo -e "\nDone."