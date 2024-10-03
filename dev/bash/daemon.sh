#!/bin/sh

# for anything hotloading (generally not very efficent)

function daemon {
  chsum1="";
  while [[ true ]]; do
    chsum2=`find -E . -iregex "\./(keycloak-app|themes|croptracker-spi)/.*\.(java|properties|ftl)" -type f -exec md5 {} \;`
    if [[ $chsum1 != $chsum2 ]] ; then           
      if [ -n "$chsum1" ]; then
        # TODO: replace the following line with your build steps
        mvn install && docker-compose down && docker-compose up -d keycloak;
      fi
      chsum1=$chsum2;
    fi
    sleep 2;
  done
}

daemon

