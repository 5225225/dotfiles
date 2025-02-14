{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = let
      p = pkgs.obs-studio-plugins;
    in [
      p.obs-pipewire-audio-capture
    ];
  };
}
