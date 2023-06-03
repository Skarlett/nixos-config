let 
  keys = import ../keys.nix;
in
{
    users.users.lunarix.openssh.authorizedKeys.keys = [ keys.flagship.lunarix ];
}