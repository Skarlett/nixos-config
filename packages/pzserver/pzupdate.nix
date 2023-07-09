{stdenv, pzdir ? "/lib/var/pzserver" }:
  stdenv.mkDerivation rec {
    passthru = { inherit pzdir; };
    name = "pzupdate.txt";
    phases = "buildPhase";
    buildPhase = ''
      mkdir -p $out
      cat >> $out/${name} <<EOF
      @ShutdownOnFailedCommand 1
      @NoPromptForPassword 1
      force_install_dir ${pzdir}
      login anonymous
      app_update 380870 validate
      quit
      EOF
    '';
  }
