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

status.register("battery",
    format="{status} {percentage:.0f}% {remaining}"
)

status.register("mpd",
    format="[<span foreground='#a1b56c'>{artist}</span>] - [<span foreground='#ac4142'>{title}</span>] - [<span foreground='#6a9fb5'>{album}</span>]",
    max_field_len=0,
    max_len=0,
    hints = {"markup": "pango"},
    interval=1
)

if os.path.isdir(os.path.expanduser("~/mail/")):
    status.register("mail",
        backends = [
            maildir.MaildirMail(
                directory = os.path.expanduser("~/mail/home/INBOX"),
                account = "Home",
            ),
            maildir.MaildirMail(
                directory = os.path.expanduser("~/mail/school/INBOX"),
                account = "School",
            ),
        ],
        interval = 1,
        format = "{account} : {unread} new email",
        format_plural = "{account} : {current_unread}/{unread} new emails",
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
