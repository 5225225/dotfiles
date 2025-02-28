{ ... }:
{
  programs = {
    mdformat = {
      enable = true;
      settings = {
        end-of-line = "lf";
        number = true;
      };
    };
    shfmt = {
      enable = true;
      indent_size = 4;
    };
    shellcheck.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    deadnix.enable = true;
    black.enable = true;
    fish_indent.enable = true;
    prettier = {
      enable = true;
      settings.tabWidth = 4;
    };
    keep-sorted.enable = true;
    typos = {
      enable = true;
      isolated = true;
    };
  };
  settings = {
    on-unmatched = "error";
    excludes = [
      "secrets/*.age"
      "flake.lock"
      "*.png"
      "user/git/allowed_signers"
      "user/mpv/uosc.conf"
      "user/rofi/theme.rasi"
      "user/xonotic/quickmenu.txt"
      # temporary for now
      "user/scripts/dmenu_mpd/dmenu_mpd"
    ];
  };
}
