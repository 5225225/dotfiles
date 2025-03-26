{ pkgs, config, ... }:
let
  piccache = pkgs.writeTextDir "p/piccache.php" (builtins.readFile ./piccache.php);
  p = pkgs.symlinkJoin {
    name = "freshrss-final";
    paths = [
      pkgs.freshrss
      piccache
    ];
  };
in
{
  services.freshrss = {
    enable = true;
    package = p;
    authType = "none";
    baseUrl = "https://iridium.tailb3553.ts.net";
    webserver = "caddy";
    extensions =
      let
        ext = pkgs.freshrss-extensions;
      in
      [
        ext.auto-ttl
        (ext.buildFreshRssExtension {
          FreshRssExtUniqueId = "ImageCache";
          pname = "image-cache";
          version = "0.4.1";
          src = pkgs.fetchFromGitHub {
            owner = "Victrid";
            repo = "freshrss-image-cache-plugin";
            rev = "37a600b1cb03732611fddf63898f48a9a31ae076";
            hash = "sha256-qIY4lx3m/vDMRNOyNNhHr5Eu717RBomYAnXV1gZewVw=";
          };
        })
      ];
  };

  services.caddy.virtualHosts.${config.services.freshrss.virtualHost} = {
    hostName = "iridium.tailb3553.ts.net";
    listenAddresses = [ "0.0.0.0" ];
  };

  services.tailscale.permitCertUid = config.services.caddy.user;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
