{
  programs = {
    mdformat = {
      enable = true;
      settings = {
        end-of-line = "lf";
        number = true;
      };
    };
    nixfmt = {
      enable = true;
      strict = true;
    };
    deadnix.enable = true;
    rustfmt = {
      enable = true;
      edition = "2024";
    };
    shfmt = {
      enable = true;
      indent_size = 4;
    };
    shellcheck.enable = true;
    taplo.enable = true;
    keep-sorted.enable = true;
    typos = {
      enable = true;
      isolated = true;
    };
  };

  settings = {
    excludes = [
      "Cargo.lock"
      "flake.lock"
      ".gitignore"
    ];
  };
}
