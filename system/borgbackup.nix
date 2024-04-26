{ config, ... }:
{
  services.borgbackup.jobs.root = {
    paths = "/";
    exclude = [
      "/nix"
      "/tmp"
      "/usr"
      "/home/jess/Downloads"
      "/home/jess/.local/share/TelegramDesktop"
      "/home/jess/.local/share/Steam/steamapps/common"
      "/home/jess/.cache"
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
  };
}
