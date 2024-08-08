{
  programs.firefox = {
    enable = true;
    profiles."1a0nke3z.default" = {
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}
