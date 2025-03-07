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
            generated = settingsFormat.generate "patch.json" patch;
          in
          ''
            if [[ -f "${absTarget}" ]]
            then
              tmpfile=$(mktemp)
              run ${lib.getExe pkgs.jd-diff-patch} -f merge -p "${generated}" -o "$tmpfile" "${absTarget}"
              mv "$tmpfile" "${absTarget}"
            else
              cp --no-preserve=all --update=none "${generated}" "${absTarget}"
            fi
          ''
        ) cfg
      )
    );
  };
}
