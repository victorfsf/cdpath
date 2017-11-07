#!/bin/bash

install() {
    declare shell="$1"
    curl https://raw.githubusercontent.com/victorfsf/cdpath/master/cdpath.sh > /usr/local/bin/cdpath.sh
    echo 'source "/usr/local/bin/cdpath.sh"' >> "$shell"
    source /usr/local/bin/cdpath.sh
    cdpath -i "$shell"
}

install "$@"
