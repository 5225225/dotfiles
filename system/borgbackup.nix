{config, ...}: {
  services.borgbackup.jobs.root = {
    paths = "/";
    exclude = [
      "/nix"
      "/tmp"
      "/usr"
      "/home/fivie/Downloads"
      "/home/fivie/.local/share/TelegramDesktop"
      "/home/fivie/.local/share/Steam/steamapps/common"
      "/home/fivie/.cache"
      "/home/jess" # TODO: remove once symlink is deleted
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
    startAt = ["3:00"];
    extraCreateArgs = "--one-file-system --exclude-caches --stats";
  };
}
