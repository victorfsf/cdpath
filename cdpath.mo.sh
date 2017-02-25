# @victorfsf - cdpath v0.1

function cdpath() {
    local bold=`tput bold`
    local green=`tput setaf 2`
    local red=`tput setaf 1`
    local reset=`tput sgr0`

    local cdfile=$HOME/.cdpath
    local shell="{{ shell }}"
    local clearEOF=':a;/^[ \n]*$/{$d;N;ba}'
    local usage="usage: cdpath [-h] [-r] [-l] [-i] [-u] <name> <path>\nSee \"cdpath -h\" for help."
    local expstr={{ expstr }}
    local grepstr={{ grepstr }}

    if [[ "$1" =~ ^\-.* ]]
    then
        case ${1} in
            -h)
                echo "cdpath basic usage: \"cdpath <name> <path>\""
                echo "    name    The path's shortcut, called with \"cd\""
                echo -e "    path    The path to link the name with\n"
                echo "cdpath options:"
                echo "    -h    Shows help"
                echo "    -r    Removes a shortcut from cdpath" \
                     "(e.g. \"cdpath -r <name>\")"
                echo "    -l    Lists all shortcuts and their respective paths"
                echo "    -i    Installs cdpath"
                echo "    -u    Uninstalls cdpath (use [-y] to skip input)"
            ;;
            -r)
                shift
                if [ -z "$1" ]
                then
                    echo "cdpath -r takes at least 1 argument (0 given)"
                    echo -e "\n$usage"
                    return 1
                else
                    for var in "$@"
                    do
                        local remove=":$var.*"
                        cat $cdfile | grep "$remove" >/dev/null
                        if [ ! $? -eq 0 ]
                        then
                            echo "${red}There's no shortcut named \"$var\"${reset}"
                            return 1
                        else
                            sed -i "s/$remove//" $cdfile
                            sed -i $clearEOF $cdfile
                            export CDPATH=".:$var:"
                            echo "${bold}Successfully removed \"$var\"${reset}"
                        fi
                    done
                fi
            ;;
            -l)
                local paths=`sed 's/^://' $cdfile`
                echo "Shortcuts:"
                if [ -z "$paths" ]
                then
                    echo "    ${bold}${red}Nothing to show here${reset}"
                    echo -e "\n$usage"
                else
                    while read item
                    do
                        local item=(`echo ${item//:/ }`)
                        if [ -z "${item[0]}" ]
                        then
                            local i=1
                        else
                            local i=0
                        fi
                        echo "    ${green}${bold}${item[$i]}" \
                             "${reset}->" \
                             "${bold}${item[`expr $i + 1`]}${item[$i]}/${reset}"
                    done <<< "$paths"
                fi
            ;;
            -u)
                if [ "$2" != "-y" ]
                then
                    echo -e -n "Are you sure you want to remove cdpath?\nAll" \
                            "your shortcuts will be lost! (y/N): "
                    read -r choice
                    local choice={{ choice }}
                else
                    local choice="y"
                fi

                if [ "$choice" == "y" ]
                then
                    echo "Uninstalling cdpath..."
                    rm -rf $cdfile
                    sed -i 's/source "$HOME\/.cdpath"//' $shell
                    cat $shell | grep "$grepstr" >/dev/null
                    if [ $? -eq 0 ]
                    then
                        cat $shell | grep -v "$grepstr" | tee $shell >/dev/null
                    fi
                    sed -i "$clearEOF" $shell
                    echo "Done."
                fi
            ;;
            -i)
                cat $shell | grep "$grepstr" >/dev/null
                if [ $? -eq 1 ]
                then
                    echo 'Installing cdpath...'
                    if [ ! -f $cdfile ]
                    then
                        touch $cdfile
                    fi
                    echo $expstr >> $shell
                    echo "Done."
                fi
            ;;
            *)
                echo "Unknown option: $1"
                echo -e "\n$usage"
                return 1
            ;;
        esac
    elif [ $# -eq 0 ]
    then
        echo -e $usage
    elif [ ! $# -eq 2 ]
    then
        echo "cdpath takes exactly 2 arguments ($# given)"
        echo -e "\n$usage"
        return 1
    else
        if [ ! -f "$cdfile" ]
        then
            touch "$cdfile"
        fi

        if [[ "$2" == "." ]]
        then
            local dest="`pwd`/"
        elif [[ "$2" == *"/" ]]
        then
            local dest="$2"
        else
            local dest="$2/"
        fi

        local baseDestDir=`basename $dest`
        if [[ "$baseDestDir" == "$1" ]]
        then
            local dest="`dirname $dest`/"
        fi

        if [[ "$dest" =~ "^[^/].*" ]]
        then
            local dest="`pwd`/$dest"
        fi

        if [ ! -d "$dest$1" ]
        then
            echo "No such directory: $dest$1"
            return 1
        fi
        sed -i 's/:'$1'.*//' $cdfile
        sed -i $clearEOF $cdfile

        if [ -z "$CDPATH" ]
        then
            export CDPATH=".:$1:$dest"
        else
            export CDPATH="$CDPATH:$1:$dest"
        fi
        echo ":$1:$dest" >> $cdfile
        sed -i $clearEOF $cdfile

        cat $shell | grep $grepstr 2>/dev/null >/dev/null
        if [ $? -eq 1 ]
        then
            echo $expstr >> $shell
        fi
    fi
}
