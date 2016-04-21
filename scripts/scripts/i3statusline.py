import os.path

from i3pystatus import Status
from i3pystatus.mail import maildir
from i3pystatus.updates import pacman, cower

def loadcfg(path):
    return open(os.path.expanduser("~/scripts/data/" + path)).read().strip()

status = Status(standalone=True)

status.register("clock",
    format=[("%A %d %B %Y %H:%M", "Europe/London")],
)

status.register("timer")

status.register("battery",
    format="{status} {percentage:.0f}% {remaining}",
    not_present_text = "",
)

status.register("network",
    interface = "wlp3s0",
    format_up = "({quality}% at {essid}) {v4}",
    format_down = "",
)

status.register("mpd",
    format="[<span foreground='#a1b56c'>{artist}</span>] - [<span foreground='#ac4142'>{title}</span>] - [<span foreground='#6a9fb5'>{album}</span>]",
    max_field_len=0,
    max_len=0,
    hints = {"markup": "pango"},
    interval=1
)

if os.path.isdir(os.path.expanduser("~/mail/school")):
    status.register("mail",
        backends = [
            maildir.MaildirMail(
                directory = os.path.expanduser("~/mail/school/INBOX"),
                account = "School",
            )],
        interval = 1,
        format = "{account} : {unread} new email",
        color_unread="#ab4642",
    )

if os.path.isdir(os.path.expanduser("~/mail/home")):
    status.register("mail",
        backends = [
            maildir.MaildirMail(
                directory = os.path.expanduser("~/mail/home/INBOX"),
                account = "Home",
            )],
        interval = 1,
        format = "{account} : {unread} new email",
        color_unread="#7cafc2",
    )


try:
    status.register("weather",
        location_code=loadcfg("location"),
        colorize="True",
        format="{current_temp}"
    )
except FileNotFoundError:
    pass

try:
    status.register("reddit",
        username="5225225",
        password=loadcfg("reddit-password"),
        mail_brackets=True,
        interval=60,
        format="{message_unread}"
    )
except FileNotFoundError:
    pass

status.register("updates",
    backends = [pacman.Pacman(),
                cower.Cower(),
    ],
    interval=3600,
    on_rightclick="~/scripts/popup-updates",
    on_doubleleftclick="urxvt -title 'REQUEST_FLOATING_WINDOW' -e ~/scripts/do-updates",
    multi_click_timeout = 1
)

try:
    status.register("github",
        username="5225225",
        password=loadcfg("github-password"),
        interval=300,
        color="#dddddd"
    )
except FileNotFoundError:
    pass


status.run()
