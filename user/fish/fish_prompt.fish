set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showcolorhints 1

set -g __fish_git_prompt_char_dirtystate "+"
set -g __fish_git_prompt_char_upstream_ahead "^"
set -g __fish_git_prompt_char_upstream_behind "v"
set -g __fish_git_prompt_char_stashstate '$'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_untrackedfiles '.'

set -g __fish_git_prompt_color_branch --bold magenta
set -g __fish_git_prompt_color_cleanstate --bold green

set -l last_pipestatus $pipestatus
set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
                                                                                                                   
# Write pipestatus
# If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
set -l bold_flag --bold
set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
if test $__fish_prompt_status_generation = $status_generation
    set bold_flag
end
set __fish_prompt_status_generation $status_generation
set -l status_color (set_color red)
set -l statusb_color (set_color $bold_flag red)
set -l prompt_status (__fish_print_pipestatus " [" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
                                                                                                                   
string join '' -- \n (fish_default_mode_prompt) (set_color yellow) (prompt_pwd --dir-length=0) (set_color normal) (fish_vcs_prompt " [%s]") "$prompt_status" \n (set_color blue) '# '
