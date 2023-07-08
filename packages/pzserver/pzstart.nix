{ stdenv
  , lib
  , bash
  , steamcmd
  , steam-run
  , pzupdate  # self.outputs.packages.pzupdate
  , pzconfig  # self.outputs.packages.pzconf.vanilla
  , pzdir ? "/var/lib/pzserver"
  # , pzworkshop # self.outputs.packages.pzworkshop
}:
  stdenv.mkDerivation rec {
    name = "pzstart";
    phases = "installPhase";
    src = ./pzstart.sh;
    buildInputs = [
      bash
      steamcmd
      steam-run
      # pzworkshop
    ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${name}
      chmod +x $out/bin/${name}

      wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath buildInputs} \
        --set PZCONFIG ${pzconfig} \
        --set PZDIR ${pzdir} \
      '';
 }
