#!/bin/bash

(

    cd "$(dirname "$0")"
    
    if [ -z "$1" ];then
        echo "[E] need arg1"
        echo "   usage $0 <dirname>"
        echo "     arg1 == 'config_<xxx>'"
        exit 1
    fi

    if ! [ -d "$1" ];then
        echo "[E] need arg1 is a dir"
        echo "   usage $0 <dirname>"
        exit 2
    fi

    workflowsDir=".github/workflows"
    if [ -e "$workflowsDir" ];then
        if ! [ -d "$workflowsDir" ];then
            exit 3
        fi
    else
        mkdir -p "$workflowsDir"
    fi

    


    dir="$(basename "$1")"
    FIRMWARE="$(echo "$dir" | sed "s/^config_//")"


    flag_small=false
    if [ -f "$dir"/compile/feeds.conf/feeds.conf.default.small ];then
        flag_small=true
    fi

    for f in "$dir"/compile/config/models/*.conf;do

        if [ ! -f "$f" ];then
            continue
        fi
        NAME="$(basename "$f")"
        NAME="$(echo "$NAME" |sed "s/.conf$//g")"
        echo "[Info] NAME=$NAME , conf=$f"

        {
            echo "# generated by $0"
            sed "s/<<<TODONAME>>>/${FIRMWARE}_${NAME}/g" action/TEMPLATE@openwrt.yml \
                | sed "s/<<<TODODIR>>>/$dir/g" \
                | sed "s/<<<TODOMODEL_NAME>>>/$NAME/g" \
                | sed "s/<<<TODOFLAG_SMALL>>>/false/g"
        } > "$workflowsDir/${FIRMWARE}_${NAME}.yml"

        if $flag_small;then
            for s in "$dir"/compile/config/small.build.luci-app.conf.small*;do
                if ! [ -f "$s" ];then
                    continue
                fi
                small="$(echo "$s" | grep -Eo "small[0-9]*$")"
                {
                    echo "# generated by $0"
                    sed "s/<<<TODONAME>>>/${FIRMWARE}_${NAME}__with_${small}/g" action/TEMPLATE@openwrt.yml \
                        | sed "s/<<<TODODIR>>>/$dir/g" \
                        | sed "s/<<<TODOMODEL_NAME>>>/$NAME/g" \
                        | sed "s/<<<TODOFLAG_SMALL>>>/$small/g"
                } > "$workflowsDir/${FIRMWARE}_${NAME}__with_${small}.yml"
            done
        fi

    done

)

# __with_small

