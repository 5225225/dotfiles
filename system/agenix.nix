{
  age.identityPaths = [ "/etc/agenix-secrets/key.txt" ];

  age.secrets.borg-password.file = ../secrets/borg-password.age;
  age.secrets.borg-ssh-key.file = ../secrets/borg-ssh-key.age;
}
