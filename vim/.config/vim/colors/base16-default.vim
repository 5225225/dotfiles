" Base16 Default (https://github.com/chriskempson/base16)
" Scheme: Chris Kempson (http://chriskempson.com)

" Terminal color definitions

let s:black     = "00"
let s:lblack    = "08"

let s:red       = "01"
let s:lred      = "09"

let s:green     = "02"
let s:lgreen    = "10"

let s:yellow    = "03"
let s:lyellow   = "11"

let s:blue      = "04"
let s:lblue     = "12"

let s:magenta   = "05"
let s:lmagenta  = "13"

let s:cyan      = "06"
let s:lcyan     = "14"

let s:white     = "07"
let s:lwhite    = "15"

" Theme setup
hi clear
syntax reset
let g:colors_name = "base16-default"

" Highlighting function
fun <sid>hi(group, ctermfg, ctermbg, attr)
  if a:ctermfg != ""
      exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
endfun

" Vim editor colors
call <sid>hi("Bold",          "", "", "bold")
call <sid>hi("Debug",         s:red, "", "")
call <sid>hi("Directory",     s:blue, "", "")
call <sid>hi("ErrorMsg",      s:red, s:black, "")
call <sid>hi("Exception",     s:red, "", "")
call <sid>hi("FoldColumn",    "", s:lgreen, "")
call <sid>hi("Folded",        s:green, "none", "bold")
call <sid>hi("IncSearch",     s:lgreen, s:lred, "none")
call <sid>hi("Italic",        "", "", "none")
call <sid>hi("Macro",         s:red, "", "")
call <sid>hi("MatchParen",    s:black, s:lblack,  "")
call <sid>hi("ModeMsg",       s:green, "", "")
call <sid>hi("MoreMsg",       s:green, "", "")
call <sid>hi("Question",      s:yellow, "", "")
call <sid>hi("Search",        s:lblack, s:yellow,  "")
call <sid>hi("SpecialKey",    s:lblack, "", "")
call <sid>hi("TooLong",       s:red, "", "")
call <sid>hi("Underlined",    s:red, "", "")
call <sid>hi("Visual",        "", s:lblack, "")
call <sid>hi("VisualNOS",     s:red, "", "")
call <sid>hi("WarningMsg",    s:red, "", "")
call <sid>hi("WildMenu",      s:red, "", "")
call <sid>hi("Title",         s:blue, "", "none")
call <sid>hi("Conceal",       s:blue, s:black, "")
call <sid>hi("Cursor",        s:black, s:white, "")
call <sid>hi("NonText",       s:lblack, "", "")
call <sid>hi("Normal",        s:white, "", "")
call <sid>hi("LineNr",        s:lblack, "", "bold")
call <sid>hi("SignColumn",    s:lblack, s:lgreen, "")
call <sid>hi("SpecialKey",    s:lblack, "", "")
call <sid>hi("StatusLine",    s:black, "", "bold")
call <sid>hi("StatusLineNC",  s:lblack, s:lgreen, "none")
call <sid>hi("VertSplit",     s:lyellow, "", "none")
call <sid>hi("ColorColumn",   "", s:lgreen, "none")
call <sid>hi("CursorColumn",  "", s:lgreen, "none")
call <sid>hi("CursorLine",    "", s:lgreen, "none")
call <sid>hi("CursorLineNr",  s:lblack, "none", "bold")
call <sid>hi("PMenu",         s:lblue, s:lgreen, "none")
call <sid>hi("PMenuSel",      s:lgreen, s:lblue, "")
call <sid>hi("TabLine",       s:lblack, s:lgreen, "none")
call <sid>hi("TabLineFill",   s:lblack, s:lgreen, "none")
call <sid>hi("TabLineSel",    s:green, s:lgreen, "none")

" Standard syntax highlighting
call <sid>hi("Boolean",      s:lred, "", "")
call <sid>hi("Character",    s:red, "", "")
call <sid>hi("Comment",      s:lblack, "", "")
call <sid>hi("Conditional",  s:magenta, "", "")
call <sid>hi("Constant",     s:lred, "", "")
call <sid>hi("Define",       s:magenta, "", "none")
call <sid>hi("Delimiter",    s:lcyan, "", "")
call <sid>hi("Float",        s:lred, "", "")
call <sid>hi("Function",     s:blue, "", "")
call <sid>hi("Identifier",   s:red, "", "none")
call <sid>hi("Include",      s:blue, "", "")
call <sid>hi("Keyword",      s:magenta, "", "")
call <sid>hi("Label",        s:yellow, "", "")
call <sid>hi("Number",       s:lred, "", "")
call <sid>hi("Operator",     s:white, "", "none")
call <sid>hi("PreProc",      s:yellow, "", "")
call <sid>hi("Repeat",       s:yellow, "", "")
call <sid>hi("Special",      s:cyan, "", "")
call <sid>hi("SpecialChar",  s:lcyan, "", "")
call <sid>hi("Statement",    s:red, "", "")
call <sid>hi("StorageClass", s:yellow, "", "")
call <sid>hi("String",       s:green, "", "")
call <sid>hi("Structure",    s:magenta, "", "")
call <sid>hi("Tag",          s:yellow, "", "")
call <sid>hi("Todo",         s:yellow, s:lgreen, "")
call <sid>hi("Type",         s:lred, "", "none")
call <sid>hi("Typedef",      s:yellow, "", "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", s:black, "undercurl")
call <sid>hi("SpellLocal",   "", s:black, "undercurl")
call <sid>hi("SpellCap",     "", s:black, "undercurl")
call <sid>hi("SpellRare",    "", s:black, "undercurl")

" Additional diff highlighting
call <sid>hi("DiffAdd",      s:green, s:black, "")
call <sid>hi("DiffChange",   s:blue, s:black, "")
call <sid>hi("DiffDelete",   s:red, s:black, "")
call <sid>hi("DiffText",     s:blue, s:black, "")
call <sid>hi("DiffAdded",    s:green, s:black, "")
call <sid>hi("DiffFile",     s:red, s:black, "")
call <sid>hi("DiffNewFile",  s:green, s:black, "")
call <sid>hi("DiffLine",     s:blue, s:black, "")
call <sid>hi("DiffRemoved",  s:red, s:black, "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:blue, "", "")
call <sid>hi("rubyConstant",                s:yellow, "", "")
call <sid>hi("rubyInterpolation",           s:green, "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:lcyan, "", "")
call <sid>hi("rubyRegexp",                  s:cyan, "", "")
call <sid>hi("rubySymbol",                  s:green, "", "")
call <sid>hi("rubyStringDelimiter",         s:green, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:white, "", "")
call <sid>hi("phpComparison",      s:white, "", "")
call <sid>hi("phpParent",          s:white, "", "")

" HTML highlighting
call <sid>hi("htmlBold",    s:yellow, "", "")
call <sid>hi("htmlItalic",  s:magenta, "", "")
call <sid>hi("htmlEndTag",  s:white, "", "")
call <sid>hi("htmlTag",     s:white, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:white, "", "")
call <sid>hi("cssClassName",   s:magenta, "", "")
call <sid>hi("cssColor",       s:cyan, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:red, "", "")
call <sid>hi("sassClassChar",  s:lred, "", "")
call <sid>hi("sassInclude",    s:magenta, "", "")
call <sid>hi("sassMixing",     s:magenta, "", "")
call <sid>hi("sassMixinName",  s:blue, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:white, "", "")
call <sid>hi("javaScriptBraces",  s:white, "", "")
call <sid>hi("javaScriptNumber",  s:lred, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:green, "", "")
call <sid>hi("markdownCodeBlock",         s:green, "", "")
call <sid>hi("markdownHeadingDelimiter",  s:blue, "", "")

" Git highlighting
call <sid>hi("gitCommitOverflow",  s:red, "", "")
call <sid>hi("gitCommitSummary",   s:green, "", "")
  
" GitGutter highlighting
call <sid>hi("GitGutterAdd",     s:green, s:lgreen, "")
call <sid>hi("GitGutterChange",  s:blue, s:lgreen, "")
call <sid>hi("GitGutterDelete",  s:red, s:lgreen, "")
call <sid>hi("GitGutterChangeDelete",  s:magenta, s:lgreen, "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     s:green, s:lgreen, "")
call <sid>hi("SignifySignChange",  s:blue, s:lgreen, "")
call <sid>hi("SignifySignDelete",  s:red, s:lgreen, "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:blue, "", "")
call <sid>hi("NERDTreeExecFile",  s:white, "", "")

" Remove functions
delf <sid>hi
