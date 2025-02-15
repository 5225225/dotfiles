let
  lg1s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
  lg2s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
  lg3s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
  lg1 = "${lg1s} --all";
  lg2 = "${lg2s} --all";
  lg3 = "${lg3s} --all";
  lg = lg1;
in
  {config, ...}: {
    programs.git = {
      enable = true;
      extraConfig = {
        core = {
          quotepath = false;
          commitGraph = true;
        };
        gc = {writeCommitGraph = true;};
        credential.helper = "store";
        init.defaultbranch = "main";
        merge.conflictstyle = "diff3";
        gpg = {
          format = "ssh";
          ssh = {allowedSignersFile = "${./allowed_signers}";};
        };
        user = {
          signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          email = "5225225@mailbox.org";
          name = "5225225";
        };
        commit = {
          gpgsign = true;
          verbose = true;
        };
        tag.gpgsign = true;
      };
      aliases = {inherit lg lg1 lg2 lg3 lg1s lg2s lg3s;};
    };
  }
