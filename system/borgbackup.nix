{ config, ... }:
{
  services.borgbackup.jobs.root = {
    paths = "/";
    exclude = [
      #keep-sorted start
      "/home/fivie/.cache"
      "/home/fivie/.config/Element/Cache/"
      "/home/fivie/.local/share/Steam/logs/"
      "/home/fivie/.local/share/Steam/steamapps/common"
      "/home/fivie/.local/share/TelegramDesktop"
      "/home/fivie/Downloads"
      "/nix"
      "/tmp"
      "/usr"
      "/var/log/journal/"
      #keep-sorted end
    ];
    doInit = false;
    repo = "okortyx0@okortyx0.repo.borgbase.com:repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets.borg-password.path}";
    };
    environment = {
      BORG_RSH = "ssh -i ${config.age.secrets.borg-ssh-key.path}";
    };
    compression = "auto,zstd,22";
    startAt = [ "3:00" ];
    extraCreateArgs = "--one-file-system --exclude-caches --stats";

    # this is a full system backup on a live system, files WILL change
    failOnWarnings = false;

    prune.keep = {
      within = "1w";
      daily = 7;
      weekly = 4;
      monthly = 12;
      yearly = -1;
    };
  };
}
