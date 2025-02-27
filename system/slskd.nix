{ config, lib, ... }:
{
  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets.slskd-env.path;
    openFirewall = true;
    domain = null;
    settings = {
      flags.force_share_scan = true;
      shares.directories = [ "[Music]/home/fivie/media/music" ];
      remote_file_management = true;
    };
  };

  systemd.services.slskd.serviceConfig.ProtectHome = lib.mkForce "tmpfs";
  systemd.services.slskd.serviceConfig.BindReadOnlyPaths = lib.mkForce [ "/home/fivie/media/music" ];
}
