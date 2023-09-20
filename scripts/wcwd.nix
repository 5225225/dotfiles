{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellApplication {
      runtimeInputs = [ pkgs.jq ];
      name = "wcwd";
      text = builtins.readFile ./wcwd.sh;
    })
  ];
}
