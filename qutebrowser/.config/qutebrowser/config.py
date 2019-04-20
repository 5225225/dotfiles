config.load_autoconfig = False

c.url.default_page = "about:blank"
c.url.start_pages = [c.url.default_page]

c.editor.command = ["urxvt", "-e", "vim", "{}"]

c.scrolling.smooth = True
c.downloads.remove_finished = 15000
c.downloads.location.prompt = False
c.statusbar.padding = {
    "bottom": 0,
    "left": 0,
    "right": 0,
    "top": 0,
}
c.completion.timestamp_format = "%Y-%m-%d %H:%M:%S"

c.completion.scrollbar.padding = 0

c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True

c.tabs.background = True
c.tabs.last_close = "close"
c.tabs.show = "never"

c.hints.mode = "number"
c.hints.auto_follow_timeout = 1500

c.input.partial_timeout = 0
c.messages.timeout = 5000

base00 = "#090300"
base01 = "#3a3432"
base02 = "#4a4543"
base03 = "#5c5855"
base04 = "#807d7c"
base05 = "#a5a2a2"
base06 = "#d6d5d4"
base07 = "#f7f7f7"
base08 = "#db2d20"
base09 = "#e8bbd0"
base0A = "#fded02"
base0B = "#01a252"
base0C = "#b5e4f4"
base0D = "#01a0e4"
base0E = "#a16a94"
base0F = "#cdab53"


BG_COLOR = base00
FG_COLOR = base07

SELECTED_BG_COLOR = base02
SELECTED_FG_COLOR = base0F

SUCCESS_COLOR = base0B
INFO_COLOR = base0D
WARN_COLOR = base0F
ERR_COLOR = base08

c.colors.completion.category.bg = BG_COLOR
c.colors.completion.category.border.bottom = BG_COLOR
c.colors.completion.category.border.top = BG_COLOR
c.colors.completion.category.fg = FG_COLOR
c.colors.completion.even.bg = BG_COLOR
c.colors.completion.fg = FG_COLOR
c.colors.completion.item.selected.bg = SELECTED_BG_COLOR
c.colors.completion.item.selected.border.bottom = BG_COLOR
c.colors.completion.item.selected.border.top = BG_COLOR
c.colors.completion.item.selected.fg = FG_COLOR
c.colors.completion.match.fg = SELECTED_FG_COLOR
c.colors.completion.odd.bg = BG_COLOR
c.colors.completion.scrollbar.bg = BG_COLOR
c.colors.completion.scrollbar.fg = FG_COLOR
c.colors.downloads.bar.bg = BG_COLOR
c.colors.downloads.error.bg = ERR_COLOR
c.colors.downloads.error.fg = FG_COLOR
c.colors.downloads.start.bg = ERR_COLOR
c.colors.downloads.start.fg = FG_COLOR
c.colors.downloads.stop.bg = SUCCESS_COLOR
c.colors.downloads.stop.fg = FG_COLOR
c.colors.downloads.system.bg = "hsl"
c.colors.downloads.system.fg = "none"
c.colors.hints.bg = BG_COLOR
c.colors.hints.fg = FG_COLOR
c.colors.hints.match.fg = SELECTED_FG_COLOR
c.colors.keyhint.bg = BG_COLOR
c.colors.keyhint.fg = FG_COLOR
c.colors.keyhint.suffix.fg = SELECTED_FG_COLOR
c.colors.messages.error.bg = ERR_COLOR
c.colors.messages.error.border = ERR_COLOR
c.colors.messages.error.fg = FG_COLOR
c.colors.messages.info.bg = INFO_COLOR
c.colors.messages.info.border = INFO_COLOR
c.colors.messages.info.fg = FG_COLOR
c.colors.messages.warning.bg = WARN_COLOR
c.colors.messages.warning.border = WARN_COLOR
c.colors.messages.warning.fg = FG_COLOR
c.colors.prompts.bg = BG_COLOR
c.colors.prompts.fg = FG_COLOR
c.colors.prompts.selected.bg = SELECTED_BG_COLOR
c.colors.statusbar.caret.bg = BG_COLOR
c.colors.statusbar.caret.fg = FG_COLOR
c.colors.statusbar.caret.selection.bg = BG_COLOR
c.colors.statusbar.caret.selection.fg = FG_COLOR
c.colors.statusbar.command.bg = BG_COLOR
c.colors.statusbar.command.fg = FG_COLOR
c.colors.statusbar.command.private.bg = BG_COLOR
c.colors.statusbar.command.private.fg = FG_COLOR
c.colors.statusbar.insert.bg = BG_COLOR
c.colors.statusbar.insert.fg = FG_COLOR
c.colors.statusbar.normal.bg = BG_COLOR
c.colors.statusbar.normal.fg = FG_COLOR
c.colors.statusbar.private.bg = BG_COLOR
c.colors.statusbar.private.fg = FG_COLOR
c.colors.statusbar.progress.bg = BG_COLOR
c.colors.statusbar.url.error.fg = ERR_COLOR
c.colors.statusbar.url.fg = FG_COLOR
c.colors.statusbar.url.hover.fg = FG_COLOR
c.colors.statusbar.url.success.http.fg = FG_COLOR
c.colors.statusbar.url.success.https.fg = SUCCESS_COLOR
c.colors.statusbar.url.warn.fg = WARN_COLOR
c.colors.tabs.bar.bg = BG_COLOR
c.colors.tabs.even.bg = BG_COLOR
c.colors.tabs.even.fg = BG_COLOR
c.colors.tabs.indicator.error = ERR_COLOR
c.colors.tabs.indicator.start = BG_COLOR
c.colors.tabs.indicator.stop = BG_COLOR
c.colors.tabs.indicator.system = "none"
c.colors.tabs.odd.bg = BG_COLOR
c.colors.tabs.odd.fg = FG_COLOR
c.colors.tabs.selected.even.bg = BG_COLOR
c.colors.tabs.selected.even.fg = FG_COLOR
c.colors.tabs.selected.odd.bg = BG_COLOR
c.colors.tabs.selected.odd.fg = FG_COLOR
c.colors.webpage.bg # Intentionally left blank.
c.fonts.monospace = "tamsyn"

config.bind("o", "set-cmd-text --space :open", mode="normal")
config.bind("O", "set-cmd-text :open {url:pretty}", mode="normal")

config.bind("t", "set-cmd-text --space :open -t", mode="normal")
config.bind("T", "set-cmd-text :open -t {url:pretty}", mode="normal")

config.bind("b", "set-cmd-text --space :buffer", mode="normal")

config.bind(",m", "hint links spawn mpv {hint-url}", mode="normal")
config.bind(",M", "spawn mpv {url}", mode="normal")

config.bind(",gr", "set-cmd-text :open https://www.reddit.com/r/", mode="normal")
config.bind(",gu", "set-cmd-text :open https://www.reddit.com/user/", mode="normal")
config.bind(",gh", "set-cmd-text :open https://www.github.com/", mode="normal")

config.bind("<Ctrl+i>", "open-editor", mode="insert")
