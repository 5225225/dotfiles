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
          body =
            #fish
            ''
              set date (date "+%F_%H-%M")
              if set -q argv[1]
                cd (mktemp --directory --tmpdir $argv[1]_{$date}_XXXX || return 1)
                nix flake init --template ~/dotfiles#templates.$argv[1]
                nix flake update 2>/dev/null
                direnv allow
              else
                cd (mktemp --directory --tmpdir empty_{$date}_XXXX || return 1)
              end
            '';
        };

        # used for async prompt
        # named inside fish_prompt.fish and shellInit
        "_vcs_prompt" = {
          description = "Wrapper around fish_vcs_prompt";
          body =
            #fish
            ''
              # keep-sorted start
              set -g __fish_git_prompt_char_dirtystate "+"
              set -g __fish_git_prompt_char_stagedstate '+'
              set -g __fish_git_prompt_char_stashstate '$'
              set -g __fish_git_prompt_char_untrackedfiles '.'
              set -g __fish_git_prompt_char_upstream_ahead "^"
              set -g __fish_git_prompt_char_upstream_behind "v"
              set -g __fish_git_prompt_color_branch --bold magenta
              set -g __fish_git_prompt_color_cleanstate --bold green
              set -g __fish_git_prompt_show_informative_status 1
              set -g __fish_git_prompt_showcolorhints 1
              set -g __fish_git_prompt_showdirtystate 1
              set -g __fish_git_prompt_showstashstate 1
              set -g __fish_git_prompt_showuntrackedfiles 1
              # keep-sorted end

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
        df = "dfc -t -devtmpfs,tmpfs,autofs -T -d -q type -W -w 2>/dev/null";
        du = "du -ch";
      };
      shellAbbrs = {
        cr = "cargo run --quiet";
        crr = "cargo run --release --quiet";
        gs = "git status";
        nrt = "run0 nixos-rebuild test";
        nrs = "run0 nixos-rebuild switch";
        nrb = "nixos-rebuild build";
        nrr = "nixos-rebuild repl";
        nr = "nix run .#";
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
    bash.bashrcExtra = ''
      # The login shell should drop into fish in interactive mode
      if [[ $- == *i* && "''${BASH##*/}" == "bashim" && -z "$BASH_EXECUTION_STRING" ]]; then
        exec -a "$0" "${config.programs.fish.package}/bin/fish"
      fi
    '';
  };

  xdg.configFile."fish/fish_variables" = {
    source = config.lib.file.mkOutOfStoreSymlink "/tmp/fish-variables-file";
    force = true;
  };
}
