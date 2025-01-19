{ ... }:
{
  programs.fish = {
    enable = true;
    functions = {
      "fish_prompt" = {
        description = "Write out the prompt";
        body = builtins.readFile ./fish_prompt.fish;
      };
    };
  };
}
