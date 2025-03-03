{ pkgs, ... }:
let
  vp = pkgs.vimPlugins;
in
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    impureRtp = false;
    wrapRc = true;
    nixpkgs.useGlobalPackages = true;
    performance = {
      byteCompileLua.enable = true;
      combinePlugins.enable = true;
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      rainbow-delimiters.enable = true;
      fugitive.enable = true;
      nui.enable = true;
      ledger.enable = true;
      nix.enable = true;
      transparent = {
        enable = true;
        settings.extra_groups = [
          "Folded"
          "DiffAdd"
          "DiffDelete"
          "DiffText"
        ];
      };
      mkdnflow = {
        enable = true;
        extraOptions.new_file_template = {
          use_template = true;
          template = ''
            +++
            title = "{{title}}"
            +++
          '';
        };
        links = {
          implicitExtension = "md";
          # TODO: this assumes i only use this for my site
          # might want to adjust this to be per-directory
          # this works fine for now though.
          transformExplicit =
            #lua
            ''
              function(text)
                text = text:gsub(" ", "-")
                text = text:lower()
                text = "@/w/"..text..".md"
                return(text)
              end
            '';
          transformImplicit =
            #lua
            ''
              function(text)
                text = string.gsub(text, "@/w/", "", 1)
                return(text)
              end
            '';
        };

        modules = {
          tables = false;
        };
      };
    };
    colorschemes.base16 = {
      enable = true;
      colorscheme = "tube";
      setUpBar = true;
    };
    extraPlugins = [
      vp.nvim-lspconfig
      vp.vim-table-mode
    ];
    opts = {
      mouse = "";
      expandtab = true;
      shiftwidth = 4;
      softtabstop = 4;
      number = true;
      tw = 99;
      smartcase = true;
      spell = true;
      gdefault = true;
      foldmethod = "expr";
    };
    globals = {
      netrw_dirhistmax = 0;

      # for transparent plugin
      transparent_enabled = true;
    };
  };
}
