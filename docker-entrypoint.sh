#!/bin/sh

set -euo pipefail

echo
# ls /docker-entrypoint-initdb.d/ > /dev/null
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh) echo "$0: running $f"; . "$f" ;;
        *)    echo "$0: ignoring $f" ;;
    esac
    echo
done

exec "$@"