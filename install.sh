#!/bin/bash

install() {
    if [ -z "$1" ]; then
        printf "install.sh takes exactly 1 argument (0 given)\n"
        printf "usage: ./install.sh <shell>\n"
        printf "       (e.g. \"./install.sh ~/.bashrc\")\n"
        return 1
    fi
    declare shell="$1"
    curl -s https://raw.githubusercontent.com/victorfsf/cdpath/master/cdpath.sh > /usr/local/bin/cdpath.sh
    cat "$shell" | grep 'source "/usr/local/bin/cdpath.sh"' >/dev/null
    if [ ! $? -eq 0 ]; then
        echo 'source "/usr/local/bin/cdpath.sh"' >> "$shell"
    fi
    source /usr/local/bin/cdpath.sh
    cdpath -i "$shell"
}

install "$@"
