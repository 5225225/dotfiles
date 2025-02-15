# Sway version of xcwd

set -x

pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.type=="con") | select(.focused==true).pid')
ppid=$(pgrep --newest --parent "${pid}" || echo "${pid}")
dir=$(readlink /proc/"${ppid}"/cwd || echo "$HOME")
if [ -d "$dir" ]; then
    echo "$dir"
else
    echo "$HOME"
fi
