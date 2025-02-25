{ pkgs, lib, ... }:
{
  programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;
    font = "Tamzen 14";
    theme = ./theme.rasi;

    # The map here is kinda a hack
    # https://github.com/NixOS/nixpkgs/issues/298539
    plugins = lib.lists.forEach [ pkgs.rofi-calc ] (
      x: x.override { rofi-unwrapped = pkgs.rofi-wayland-unwrapped; }
    );
  };
}
