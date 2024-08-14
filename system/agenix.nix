{
  age = {
    identityPaths = [ "/etc/agenix-secrets/key.txt" ];
    secrets.borg-password.file = ../secrets/borg-password.age;
    secrets.borg-ssh-key.file = ../secrets/borg-ssh-key.age;
  };
}
