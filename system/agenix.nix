{
  age = {
    identityPaths = [ "/etc/agenix-secrets/key.txt" ];
    secrets = {
      borg-password.file = ../secrets/borg-password.age;
      borg-ssh-key.file = ../secrets/borg-ssh-key.age;
      fishnet-key.file = ../secrets/fishnet-key.age;
    };
  };
}
