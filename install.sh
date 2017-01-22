#!/bin/bash

./render.sh

function install_cdpath() {
    if [ ! -f cdpath/cdpath.$1.sh ]
    then
        sudo curl -o /usr/local/bin/cdpath.sh https://raw.githubusercontent.com/victorfsf/cdpath/master/cdpath/cdpath.$1.sh
    else
        sudo cp cdpath/cdpath.$1.sh /usr/local/bin/cdpath.sh
    fi
    cat $2 | grep "source \(\'\|\"\)/usr/local/bin/cdpath.sh\(\'\|\"\)" >/dev/null
    if [ $? == 1 ]
    then
        echo 'source "/usr/local/bin/cdpath.sh"' >> $2
    fi
}

case "${1}" in
    -zsh)
        install_cdpath zsh ~/.zshrc
    ;;
    -bash)
    ;;
    *)
        install_cdpath bash ~/.bashrc
    ;;
esac
