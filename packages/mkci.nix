
{ self
  , self-lib
  , stdenv
  , lib
  , yq
  , override-workflow ? []
  , pkg-fn ? self-lib.workflow.mkNixBuild
  , host-fn ? self-lib.workflow.mkNixosBuild
}:
  let
    inherit (self-lib) recursiveMerge;

    names = xs: builtins.attrNames (builtins.removeAttrs xs ["override" "overrideDerivation"]);

    dry-hosts =
      (map (name: host-fn { inherit name; }))
        (names self.nixosConfigurations);

    bpkgs =
      (map (name: pkg-fn { inherit name; }))
        (names self.packages.${stdenv.hostPlatform.system});

    buildFlows = (dry-hosts ++ bpkgs);
    onames = (map (x: x.name) override-workflow);
    reserved = builtins.filter(bf: !(builtins.elem bf.name onames)) buildFlows;

    newBuildFlows =
      reserved ++ override-workflow;

    # Write an entry for each workflow to the output directory
    wrapWriter = wf: ''
      yq -y --yml-out-ver "1.2" > $out/${wf.name}.yaml <<EOF
      ${(lib.escape ["$"] (lib.generators.toYAML {} wf))}
      EOF
    '';

    buildscript = lib.strings.concatStringsSep
      "\n"
      ((map wrapWriter) newBuildFlows);

  in stdenv.mkDerivation {
    name="workflow-codegen";
    phases = "buildPhase";
    buildPhase = ''
        mkdir $out
        ${buildscript}
      '';
    nativeBuildInputs = [ yq ];
  }
