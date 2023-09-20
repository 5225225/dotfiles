{pkgs, ...}:
let
  time = pkgs.writeShellApplication {
    name = "time";
    runtimeInputs = [pkgs.libnotify];
    text = ''
      case $BLOCK_BUTTON in
      3)
          notify-send "time" "$(date '+%Y-%m-%d %H:%M:%S  %Z (%:::z)')\n\
      $(TZ=Universal date '+%Y-%m-%d %H:%M:%S  %Z (%:::z)')\n\
      $(cal)"
      ;;
      esac
      date "+%a %d %b %Y %H:%M"
    '';
  };
in
{
  home.file.".config/i3blocks/config".text = ''
    interval = 1

    [time]
    command = ${time}
  '';
  home.packages = [ pkgs.i3blocks ];
}
