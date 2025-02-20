{
  pkgs,
  config,
  ...
}: {
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
      '';
    };

    bash.enable = true;
    bash.initExtra = ''
      [[ -x "${config.programs.fish.package}/bin/fish" ]] && exec ${config.programs.fish.package}/bin/fish
    '';
  };
}
