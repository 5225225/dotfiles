{ pkgs, config, ...}:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "exa --group-directories-first --git --extended";
      df = "dfc -t -devtmpfs,tmpfs,autofs -T -d -q type -W -w 2>/dev/null";
      du = "du -ch";
    };
    history = {
      path = "${config.xdg.stateHome}/zsh/histfile";
      save = 999999999;
      size = 999999999;
    };
    localVariables = {
      ZSH_AUTOSUGGEST_STRATEGY = ["completion"];
      ZSH_AUTOSUGGEST_USE_ASYNC="trans rights"; # i was told it could be set to anything
      ZSH_HIGHLIGHT_HIGHLIGHTERS=["main" "pattern" "brackets" "root"];
    };
    envExtra = ''
      setopt no_global_rcs
    '';
    initExtraFirst = ''. ${./zshrc}'';
    plugins = [{
      # will source zsh-autosuggestions.plugin.zsh
      name = "git-prompt.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "woefe";
        repo = "git-prompt.zsh";
        rev = "55f40bdfb287122ea50c1c01ef056ca7dac175e5";
        sha256 = "sha256-7sBXM7o+qFsk6vMlXWvRp8bhxBuOznoXQ4I+7vkmvgg=";
      };
    }];
  };

}
