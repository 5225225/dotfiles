let
  lg1s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
  lg2s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
  lg3s = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
  lg1 = "${lg1s} --all";
  lg2 = "${lg2s} --all";
  lg3 = "${lg3s} --all";
  lg = lg1;
in
{ config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases = {
      inherit
        lg
        lg1
        lg2
        lg3
        lg1s
        lg2s
        lg3s
        ;
    };
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
    userEmail = "5225225@mailbox.org";
    userName = "5225225";
    delta = {
      enable = true;
      options = {
        line-numbers = true;
      };
    };
    extraConfig = {
      core = {
        quotepath = false;
        commitGraph = true;
      };
      gc = {
        writeCommitGraph = true;
      };
      credential.helper = "store";
      init.defaultbranch = "main";
      merge.conflictstyle = "diff3";
      gpg.ssh = {
        allowedSignersFile = "${./allowed_signers}";
      };
      commit.verbose = true;
    };
  };
}
