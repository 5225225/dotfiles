{pkgs, ...}: {
  home.packages = [pkgs.xonotic];

  home.file.".xonotic/data/quickmenu.txt".source = ./quickmenu.txt;
}
