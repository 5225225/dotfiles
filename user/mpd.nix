{ config, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/media/music";
    extraConfig = ''
      audio_output {
        type  "pipewire"
        name  "Pipewire Sound Server"
      }

      replaygain "auto"

      max_output_buffer_size "32768"
      max_command_list_size "8192"
      auto_update "yes"
    '';
  };
}
