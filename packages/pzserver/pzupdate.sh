#!/usr/bin/env sh
if [ ! -f $PZUPDATE ]; then
    echo "No update script found at $PZUPDATE"
    exit 1
fi

steamcmd +runscript $PZUPDATE
