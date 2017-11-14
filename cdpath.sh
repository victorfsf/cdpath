#!/bin/bash

cdpath() {
    local bold=`tput bold`
    local green=`tput setaf 2`
    local red=`tput setaf 1`
    local reset=`tput sgr0`

    local usage="usage: cdpath [-h] [-r] [-l] [-i] [-u] <name> <path>\nSee \"cdpath -h\" for help.\n"
    local cdfile="$HOME/.cdpath"
    local clearEOF=':a;/^[ \n]*$/{$d;N;ba}'
    local expstr='export CDPATH=".$(cat "$HOME/.cdpath" | sed ":a;N;$ba;s/\\n//g")"'
    local grepstr="export CDPATH"

    case_h() {
        printf "cdpath basic usage: \"cdpath <name> <path>\"\n"
        printf "    name    The path's shortcut, called with \"cd\"\n"
        printf "    path    The path to link the name with\n\n"
        printf "cdpath options:\n"
        printf "    -h    Shows help\n"
        printf "    -r    Removes a shortcut from cdpath "
        printf "(e.g. \"cdpath -r <name>\")\n"
        printf "    -l    Lists all shortcuts and their respective paths\n"
        printf "    -i    Installs cdpath "
        printf "(e.g. \"cdpath -i ~/.bashrc\")\n"
        printf "    -u    Uninstalls cdpath "
        printf "(e.g. \"cdpath -u ~/.bashrc\")\n"
    }

    case_r() {
        if [ -z "$1" ]; then
            printf "cdpath -r takes at least 1 argument (0 given)\n"
            printf "\n$usage"
            return 1
        else
            for var in "$@"; do
                local remove=":$var:.*"
                if cat "$cdfile" | grep "$remove" >/dev/null; then
                    sed -i "s/$remove//" "$cdfile"
                    sed -i "$clearEOF" "$cdfile"
                    export CDPATH=".:$var:"
                    printf "${bold}Successfully removed \"$var\"${reset}\n"
                else
                    printf "${red}There's no shortcut named \"$var\"${reset}\n"
                    return 1
                fi
            done
        fi
    }

    case_l() {
        local paths=$(sed 's/^://' "$cdfile")
        printf "Shortcuts:\n"
        if [ -z "$paths" ]
        then
            printf "    ${bold}${red}Nothing to show here${reset}\n\n$usage"
        else
            while read item; do
                local item=(`echo ${item//:/ }`)
                if [ -z "${item[0]}" ]; then
                    local i=1
                else
                    local i=0
                fi
                printf "    ${green}${bold}${item[$i]} "
                printf "${reset}➜ "
                printf "${bold}${item[`expr $i + 1`]}${item[$i]}/${reset}\n"
            done <<< "$paths"
        fi
    }

    case_u() {
        if [ -z "$1" ]; then
            printf "cdpath -u takes at least 1 argument (0 given)\n"
            printf "\n$usage"
            return 1
        else
            declare shell="$1"
            printf "Uninstalling cdpath...\n"
            rm -rf "$cdfile"
            sed -i 's/source "$HOME\/.cdpath"//' "$shell"

            if cat "$shell" | grep "$grepstr" >/dev/null; then
                cat "$shell" | grep -v "$grepstr" | tee "$shell" >/dev/null
            fi
            sed -i "$clearEOF" "$shell"
            printf "Done.\n"
        fi
    }

    case_i() {
        if [ -z "$1" ]; then
            printf "cdpath -i takes at least 1 argument (0 given)\n"
            printf "\n$usage"
            return 1
        else
            declare shell="$1"
            if cat "$shell" | grep "$grepstr" >/dev/null; then
                printf "${red}cdpath is already installed on \"$shell\".\n"
            else
                printf "Installing cdpath...\n"
                if [ ! -f "$cdfile" ]
                then
                    touch "$cdfile"
                fi
                echo "$expstr" >> "$shell"
                printf "Done.\n"
            fi
        fi
    }

    case_default() {
        printf "Unknown option: $1\n\n$usage"
    }

    if [[ "$1" =~ ^\-.* ]]; then
        case "${1}" in
            -h) case_h ;;
            -r) shift; case_r "$@" ;;
            -l) case_l ;;
            -u) shift; case_u "$@" ;;
            -i) shift; case_i "$@" ;;
            *) case_default "$1" ;;
        esac
    elif [ "$#" -eq 0 ]; then
        printf "$usage"
    elif [ ! "$#" -eq 2 ]; then
        printf "cdpath takes exactly 2 arguments ($# given)\n"
        printf "\n$usage"
        return 1
    else
        if [ ! -f "$cdfile" ]; then
            touch "$cdfile"
        fi

        if [[ "$2" == "." ]]; then
            local dest="$(pwd)/"
        elif [[ "$2" == *"/" ]]; then
            local dest="$2"
        else
            local dest="$2/"
        fi

        local baseDestDir=$(basename $dest)
        if [[ "$baseDestDir" == "$1" ]]; then
            local dest="$(dirname $dest)/"
        fi

        if [[ "$dest" =~ "^[^/].*" ]]; then
            local dest="$(pwd)/$dest"
        fi

        if [ ! -d "$dest$1" ]; then
            printf "No such directory: $dest$1\n"
            return 1
        fi
        sed -i 's/:'$1'.*//' "$cdfile"
        sed -i "$clearEOF" "$cdfile"

        if [ -z "$CDPATH" ]; then
            export CDPATH=".:$1:$dest"
        else
            export CDPATH="$CDPATH:$1:$dest"
        fi
        echo ":$1:$dest" >> "$cdfile"
        sed -i "$clearEOF" "$cdfile"
    fi
}

alias cdp="cdpath"
