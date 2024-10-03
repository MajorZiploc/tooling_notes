#!/bin/sh

daemon() {
    chsum1="";
    while [[ true ]]; do
        chsum2=`find -E . -iregex "\./.*\.(java|properties|ftl|json)" -type f -exec md5 {} \;`
        if [[ $chsum1 != $chsum2 ]] ; then           
            if [ -n "$chsum1" ]; then
                # command to build and run
                docker compose down && docker compose up -d;
            fi
            chsum1=$chsum2;
        fi
        sleep 2;
    done
}

daemon

