{name, cmd}:
{
  ${name} = {
    runs-on = "ubuntu-latest";
    steps = [
      {uses = "actions/checkout@v3"; }
      {uses = "actions/install-nix-action@v20";
       "with" = {
         nix_path = "nixpkgs=channel:nixos-unstable";
         github_access_token = "\${{ secrets.GITHUB_TOKEN }}";
       };}
      { run = cmd; }
    ];
  };
}
