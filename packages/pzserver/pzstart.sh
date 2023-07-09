if [ ! -f $PZUPDATE ]; then
    echo "No update script found at $PZUPDATE"
    exit 1
fi

# pz-workshops --print-missing $PZINI || exit 1
# run update script first
steamcmd +runscript $PZUPDATE

mkdir -p $PZDIR/Server

cp -f $PZDEPLOY_CONFIG/* $PZDIR/Server

if [ -e $PZINI ]; then
    echo "Found $PZINI"
    cp -f $PZINI $PZDIR
fi

steam-run bash ${PZDIR}/start-server.sh
