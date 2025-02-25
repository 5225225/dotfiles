{ pkgs, config, ... }:
{
  programs = {
    fish = {
      enable = true;
      plugins = [
        {
          name = "async-prompt";
          inherit (pkgs.fishPlugins.async-prompt) src;
        }
      ];
      functions = {
        "fish_prompt" = {
          description = "Write out the prompt";
          body = builtins.readFile ./fish_prompt.fish;
        };
        "cd" = {
          description = "Change directory and also print CWD";
          wraps = "cd";
          body = ''
            builtin cd $argv && ls
          '';
        };
        "scratch" = {
          description = "Makes a temporary directory and moves into it";
          body = ''
            cd "$(mktemp --tmpdir -d scratchXXXXXXXXX)"
          '';
        };

        # used for async prompt
        # named inside fish_prompt.fish and shellInit
        "_vcs_prompt" = {
          description = "Wrapper around fish_vcs_prompt";
          body =
            #fish
            ''
              set -g __fish_git_prompt_show_informative_status 1
              set -g __fish_git_prompt_showuntrackedfiles 1
              set -g __fish_git_prompt_showdirtystate 1
              set -g __fish_git_prompt_showuntrackedfiles 1
              set -g __fish_git_prompt_showstashstate 1
              set -g __fish_git_prompt_showcolorhints 1

              set -g __fish_git_prompt_char_dirtystate "+"
              set -g __fish_git_prompt_char_upstream_ahead "^"
              set -g __fish_git_prompt_char_upstream_behind "v"
              set -g __fish_git_prompt_char_stashstate '$'
              set -g __fish_git_prompt_char_stagedstate '+'
              set -g __fish_git_prompt_char_untrackedfiles '.'

              set -g __fish_git_prompt_color_branch --bold magenta
              set -g __fish_git_prompt_color_cleanstate --bold green

              fish_vcs_prompt " [%s]"
            '';
        };

        # Stop the vi mode being shown.
        # https://fishshell.com/docs/current/interactive.html#vi-mode-commands
        # > When in vi-mode, the fish_mode_prompt function will display a mode indicator to the
        # > left of the prompt. To disable this feature, override it with an empty function.
        "fish_mode_prompt".body = "";
      };
      shellAliases = {
        ls = "eza --group-directories-first --git --extended";
        df = "dfc -t -devtmpfs,tmpfs,autofs -T -d -q type -W -w 2>/dev/null";
        du = "du -ch";
      };
      shellAbbrs = {
        cr = "cargo run --quiet";
        crr = "cargo run --release --quiet";
        gs = "git status";
      };
      shellInit = ''
        set --global fish_greeting
        set --global fish_key_bindings fish_vi_key_bindings

        bind --mode insert \cr history-pager

        # defined in fish_prompt.fish
        set --global async_prompt_functions _vcs_prompt
      '';
    };

    bash.enable = true;
    bash.initExtra = ''
      [[ -x "${config.programs.fish.package}/bin/fish" ]] && exec ${config.programs.fish.package}/bin/fish
    '';
  };
}
