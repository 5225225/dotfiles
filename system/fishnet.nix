{
  pkgs,
  config,
  ...
}: {
  systemd.services.fishnet = {
    unitConfig = {
      Description = "fishnet: distributed Stockfish analysis for lichess.org";
      After = "network-online.target";
      Wants = "network-online.target";
    };

    serviceConfig = {
      LoadCredential = "fishnet-key:${config.age.secrets.fishnet-key.path}";
      ExecStart = "${pkgs.fishnet}/bin/fishnet --no-conf --cores 4 --stats-file %S/fishnet/stats --key-file %d/fishnet-key run";
      KillMode = "mixed";
      WorkingDirectory = "/tmp";
      PrivateTmp = true;
      PrivateDevices = true;
      CapabilityBoundingSet = "";
      ProtectSystem = "full";
      NoNewPrivileges = true;
      DynamicUser = true;
      StateDirectory = "fishnet";
      Restart = "on-failure";
    };

    wantedBy = ["multi-user.target"];
  };
}
