{ pkgs, config, git-prompt, ... }: {
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
      ignoreDups = true;
      path = "${config.xdg.stateHome}/zsh/histfile";
      save = 999999999;
      size = 999999999;
    };
    localVariables = {
      ZSH_AUTOSUGGEST_STRATEGY = [ "completion" ];
      ZSH_AUTOSUGGEST_USE_ASYNC =
        "trans rights"; # i was told it could be set to anything

      ZSH_HIGHLIGHT_HIGHLIGHTERS = [ "main" "pattern" "brackets" "root" ];

      ZSH_THEME_GIT_PROMPT_PREFIX = " [";
      ZSH_THEME_GIT_PROMPT_SUFFIX = "] ";
      ZSH_THEME_GIT_PROMPT_SEPARATOR = "|";
      ZSH_THEME_GIT_PROMPT_DETACHED = "%{$fg_bold[cyan]%}:";
      ZSH_THEME_GIT_PROMPT_BRANCH = "%{$fg_bold[magenta]%}";
      ZSH_THEME_GIT_PROMPT_BEHIND = "v";
      ZSH_THEME_GIT_PROMPT_AHEAD = "^";
      ZSH_THEME_GIT_PROMPT_UNMERGED = "%{$fg[red]%}x";
      ZSH_THEME_GIT_PROMPT_STAGED = "%{$fg[green]%}o";
      ZSH_THEME_GIT_PROMPT_UNSTAGED = "%{$fg[red]%}+";
      ZSH_THEME_GIT_PROMPT_UNTRACKED = ".";
      ZSH_THEME_GIT_PROMPT_STASHED = "%{$fg[blue]%}&";
      ZSH_THEME_GIT_PROMPT_CLEAN = "%{$fg_bold[green]%}✔";

      ZSH_GIT_PROMPT_SHOW_STASH = 1;
    };
    envExtra = ''
      setopt no_global_rcs
    '';
    initExtraFirst = ''
      autoload -U colors
      colors
    '';
    autocd = false;
    initExtra = ". ${./zshrc}";
    plugins = [{
      name = "git-prompt";
      src = git-prompt;
    }];
  };
}
