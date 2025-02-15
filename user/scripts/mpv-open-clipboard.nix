{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication {
      runtimeInputs = [pkgs.wl-clipboard];
      name = "mpv-open-clipboard";
      text = ''
        url="$(wl-paste --primary)"
        notify-send "mpv" "opening url $url"
        mpv "$url"
      '';
    })
  ];
}
