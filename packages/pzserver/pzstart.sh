
mkdir -p $PZDIR/Zomboid/

$UPDATE && pzupdate
$DECLARATIVE && ln -s $PZGEN $PZDIR/Zomboid/Server

steam-run bash ${PZDIR}/start-server.sh
