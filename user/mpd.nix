{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/media/music";
    extraConfig = ''
      audio_output {
        type  "pipewire"
        name  "Pipewire Sound Server"
      }

      replaygain "auto"

      max_output_buffer_size "32768"
      max_command_list_size "8192"
      auto_update "yes"
    '';
  };

  systemd.user.services.mpd.Service = {
    KeyringMode = "private";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateMounts = "yes";
    PrivateTmp = "yes";
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    ReadWritePaths = [ config.services.mpd.dataDir ];
    ReadOnlyPaths = [ config.services.mpd.musicDirectory ];
    RemoveIPC = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    PrivateUsers = true;
    ProtectProc = "noaccess";
    CapabilityBoundingSet = "";
    PrivateDevices = true;
    ProtectClock = true;
    ProtectKernelLogs = true;

    # TODO: @default isn't enough here and i don't care enough to find out why
    # bash fails on it, in any case
    SystemCallFilter = "@system-service";
    SystemCallArchitectures = "native";
  };
}
