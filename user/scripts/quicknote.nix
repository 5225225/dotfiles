{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      runtimeInputs = [];
      name = "quicknote";
      text = ''
        foot --app-id=quicknote-editor-floating \
          -W150x60 \
          -o "colors.alpha=0.95" \
          vim + ~/sync/documents/quicknote.md
      '';
    })
  ];
}
