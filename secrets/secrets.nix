let 
  user-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/oBua4Sd+/mZYCDbxrojc26e5QzXlpMjLsRlAspcE6";
  
  system-desktop = "age1s932c06eemqyh48vxu7xm4z7hdc0a87jhzunr7ww3fa35ltahyessg3f22";
  all = [user-desktop system-desktop];
in
{
  "listenbrainz-mpd-token.age".publicKeys = all;
  "borg-password.age".publicKeys = [system-desktop];
  "borg-ssh-key.age".publicKeys = [system-desktop];
}
