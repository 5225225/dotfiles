{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.patch.json-merge;
  settingsFormat = pkgs.formats.json { };
in
{
  options.patch.json-merge = lib.mkOption {
    type = lib.types.attrsOf (settingsFormat.type);
    default = { };
  };

  config = {
    home.activation.jsonpatch-files = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          target: patch:
          let
            absTarget = "${config.home.homeDirectory}/${target}";
          in
          "run ${lib.getExe pkgs.jd-diff-patch} -f merge -p ${settingsFormat.generate "patch.json" patch} ${absTarget} | ${lib.getExe' pkgs.moreutils "sponge"} ${absTarget}"
        ) cfg
      )
    );

    home.activation.jsonpatch-files-check = lib.hm.dag.entryBefore [ "writeBoundary" ] (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          target: patch:
          let
            absTarget = "${config.home.homeDirectory}/${target}";
          in
          "run --quiet ${lib.getExe pkgs.jd-diff-patch} -f merge -p ${settingsFormat.generate "patch.json" patch} ${absTarget}"
        ) cfg
      )
    );
  };
}
