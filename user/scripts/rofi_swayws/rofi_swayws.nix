{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellApplication {
      runtimeInputs = [ pkgs.sway pkgs.rofi pkgs.jq ];
      name = "rofi_swayws";
      text = builtins.readFile ./rofi_swayws.sh;
    })
  ];
}
