{ stdenv
  , lib
  , bash
  , makeWrapper
  , steamcmd
  , steam-run
  , pzupdate
  , pzconfig  # self.outputs.packages.pzconf.vanilla
  # , pzworkshop # self.outputs.packages.pzworkshop
}:
  stdenv.mkDerivation rec {
    name = "pzstart";
    phases = "installPhase";
    src = ./pzstart.sh;
    buildInputs = [
      makeWrapper
      bash
      steamcmd
      steam-run
      pzupdate
      pzconfig
      # pzworkshop
    ];
    installPhase = ''
      mkdir -p $out/bin
      cp -r $src $out/bin/${name}
      chmod +x $out/bin/${name}

      wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath buildInputs} \
        --set PZCONFIG ${pzconfig} \
        --set PZUPDATE ${pzupdate}/pzupdate.txt \
        --set PZDIR ${pzupdate.passthru.pzdir} \
      '';
    passthru = {
      inherit pzconfig pzupdate;
      pzdir = pzupdate.passthru.pzdir;
    };
 }
