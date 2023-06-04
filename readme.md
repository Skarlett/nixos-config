# Nixos configuration

the current systems are the following:

- `nixosConfiguration.flagship`: dell optiplex, main
    - cinnamon & lightdm
    - home manager + nur + nix 
    
- `nixosConfiguration.coggie`:
    - no desktop env
    - raspberry pi 3b
    - `nix build .#nixosConfigurations.coggie.config.system.build.sdImage`
    - `zstd -dc /dev/mmcblk0`
    - `deploy-rs -s`   