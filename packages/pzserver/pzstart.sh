PZDIR=${PZDIR:-"/var/lib/project-zomboid"}
PZUPDATE=${STEAMCMD:-"$PZDIR/pzupdate.txt"}
PZCONFIG=${PZCONFIG:-"$PZDIR/Server"}
PZINI=${PZINI:-"$PZDIR/servertest.ini"}

if [ ! -f $PZUPDATE ]; then
    echo "No update script found at $PZUPDATE"
    exit 1
fi

# pz-workshops --print-missing $PZINI || exit 1
# run update script first

steamcmd +runscript $PZUPDATE
cp -f $PZDEPLOY_CONFIG/* $PZDIR/Server

if [ -e $PZINI ]; then
    echo "Found $PZINI"
    cp -f $PZINI $PZDIR
fi

export LD_LIBRARY_PATH="${PZDIR}/linux64:${PZDIR}/natives:${PZDIR}:${PZDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
export LD_PRELOAD="${LD_PRELOAD}:${PZDIR}/libjsig.so"

pushd $PZDIR
${PZDIR}/ProjectZomboid64 "$@"
popd
