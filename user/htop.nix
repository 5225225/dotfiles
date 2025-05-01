{
  programs.htop = {
    enable = true;

    settings = {
      shadow_other_users = true;
      show_thread_names = true;
      shadow_distribution_path_prefix = true;
      show_merged_command = true;
      show_cpu_temperature = true;
    };
  };
}
