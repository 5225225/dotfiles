{pkgs, ...}: {
  systemd.services.yarr = {
    unitConfig = {
      Description = "yarr: yet another rss reader";
    };

    serviceConfig = {
      ExecStart = "${pkgs.yarr}/bin/yarr";
      DynamicUser = true;
      StateDirectory = "yarr";

      PrivateUsers = true;
      ProtectHostname = true;
      ProtectHome = true;
      LockPersonality = true;
      CapabilityBoundingSet = "~CAP_LINUX_IMMUTABLE CAP_IPC_LOCK CAP_SYS_MODULE CAP_KILL CAP_BPF CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_TTY_CONFIG CAP_SYS_TIME CAP_SYS_PACCT CAP_WAKE_ALARM CAP_BLOCK_SUSPEND CAP_LEASE CAP_MKNOD";
      SystemCallFilter = "~@obsolete @privileged";
    };

    environment = {
      YARR_DB = "%S/yarr/yarr-db.sqlite";

      # TODO: yarr 2.4 unconditionally fails if HOME or XDG_CONFIG_HOME isn't set
      # this has been fixed in newer versions, but a tagged release wasn't made yet
      # this won't actually be used
      XDG_CONFIG_HOME = "/ignored";
    };

    wantedBy = ["default.target"];
  };
}
