{ pkgs, ... }:
{
  home.packages = [
    (pkgs.python3Packages.buildPythonApplication {
      pname = "dmenu_mpd";
      version = "1.0";
      src = ./.;
      format = "setuptools";
    })
  ];
}
