" Base16 Default (https://github.com/chriskempson/base16)
" Scheme: Chris Kempson (http://chriskempson.com)

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
call <sid>hi("Debug",         "01", "", "")
call <sid>hi("Directory",     "04", "", "")
call <sid>hi("ErrorMsg",      "01", "00", "")
call <sid>hi("Exception",     "01", "", "")
call <sid>hi("FoldColumn",    "", "10", "")
call <sid>hi("Folded",        "08", "10", "")
call <sid>hi("IncSearch",     "10", "09", "none")
call <sid>hi("Italic",        "", "", "none")
call <sid>hi("Macro",         "01", "", "")
call <sid>hi("MatchParen",    "00", "08",  "")
call <sid>hi("ModeMsg",       "02", "", "")
call <sid>hi("MoreMsg",       "02", "", "")
call <sid>hi("Question",      "03", "", "")
call <sid>hi("Search",        "08", "03",  "")
call <sid>hi("SpecialKey",    "08", "", "")
call <sid>hi("TooLong",       "01", "", "")
call <sid>hi("Underlined",    "01", "", "")
call <sid>hi("Visual",        "", "08", "")
call <sid>hi("VisualNOS",     "01", "", "")
call <sid>hi("WarningMsg",    "01", "", "")
call <sid>hi("WildMenu",      "01", "", "")
call <sid>hi("Title",         "04", "", "none")
call <sid>hi("Conceal",       "04", "00", "")
call <sid>hi("Cursor",        "00", "07", "")
call <sid>hi("NonText",       "08", "", "")
call <sid>hi("Normal",        "07", "", "")
call <sid>hi("LineNr",        "08", "", "bold")
call <sid>hi("SignColumn",    "08", "10", "")
call <sid>hi("SpecialKey",    "08", "", "")
call <sid>hi("StatusLine",    "00", "", "bold")
call <sid>hi("StatusLineNC",  "08", "10", "none")
call <sid>hi("VertSplit",     "11", "", "none")
call <sid>hi("ColorColumn",   "", "10", "none")
call <sid>hi("CursorColumn",  "", "10", "none")
call <sid>hi("CursorLine",    "", "10", "none")
call <sid>hi("CursorLineNr",  "08", "none", "bold")
call <sid>hi("PMenu",         "12", "10", "none")
call <sid>hi("PMenuSel",      "10", "12", "")
call <sid>hi("TabLine",       "08", "10", "none")
call <sid>hi("TabLineFill",   "08", "10", "none")
call <sid>hi("TabLineSel",    "02", "10", "none")

" Standard syntax highlighting
call <sid>hi("Boolean",      "09", "", "")
call <sid>hi("Character",    "01", "", "")
call <sid>hi("Comment",      "08", "", "")
call <sid>hi("Conditional",  "05", "", "")
call <sid>hi("Constant",     "09", "", "")
call <sid>hi("Define",       "05", "", "none")
call <sid>hi("Delimiter",    "14", "", "")
call <sid>hi("Float",        "09", "", "")
call <sid>hi("Function",     "04", "", "")
call <sid>hi("Identifier",   "01", "", "none")
call <sid>hi("Include",      "04", "", "")
call <sid>hi("Keyword",      "05", "", "")
call <sid>hi("Label",        "03", "", "")
call <sid>hi("Number",       "09", "", "")
call <sid>hi("Operator",     "07", "", "none")
call <sid>hi("PreProc",      "03", "", "")
call <sid>hi("Repeat",       "03", "", "")
call <sid>hi("Special",      "06", "", "")
call <sid>hi("SpecialChar",  "14", "", "")
call <sid>hi("Statement",    "01", "", "")
call <sid>hi("StorageClass", "03", "", "")
call <sid>hi("String",       "02", "", "")
call <sid>hi("Structure",    "05", "", "")
call <sid>hi("Tag",          "03", "", "")
call <sid>hi("Todo",         "03", "10", "")
call <sid>hi("Type",         "09", "", "none")
call <sid>hi("Typedef",      "03", "", "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", "00", "undercurl")
call <sid>hi("SpellLocal",   "", "00", "undercurl")
call <sid>hi("SpellCap",     "", "00", "undercurl")
call <sid>hi("SpellRare",    "", "00", "undercurl")

" Additional diff highlighting
call <sid>hi("DiffAdd",      "02", "00", "")
call <sid>hi("DiffChange",   "04", "00", "")
call <sid>hi("DiffDelete",   "01", "00", "")
call <sid>hi("DiffText",     "04", "00", "")
call <sid>hi("DiffAdded",    "02", "00", "")
call <sid>hi("DiffFile",     "01", "00", "")
call <sid>hi("DiffNewFile",  "02", "00", "")
call <sid>hi("DiffLine",     "04", "00", "")
call <sid>hi("DiffRemoved",  "01", "00", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               "04", "", "")
call <sid>hi("rubyConstant",                "03", "", "")
call <sid>hi("rubyInterpolation",           "02", "", "")
call <sid>hi("rubyInterpolationDelimiter",  "14", "", "")
call <sid>hi("rubyRegexp",                  "06", "", "")
call <sid>hi("rubySymbol",                  "02", "", "")
call <sid>hi("rubyStringDelimiter",         "02", "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  "07", "", "")
call <sid>hi("phpComparison",      "07", "", "")
call <sid>hi("phpParent",          "07", "", "")

" HTML highlighting
call <sid>hi("htmlBold",    "03", "", "")
call <sid>hi("htmlItalic",  "05", "", "")
call <sid>hi("htmlEndTag",  "07", "", "")
call <sid>hi("htmlTag",     "07", "", "")

" CSS highlighting
call <sid>hi("cssBraces",      "07", "", "")
call <sid>hi("cssClassName",   "05", "", "")
call <sid>hi("cssColor",       "06", "", "")

" SASS highlighting
call <sid>hi("sassidChar",     "01", "", "")
call <sid>hi("sassClassChar",  "09", "", "")
call <sid>hi("sassInclude",    "05", "", "")
call <sid>hi("sassMixing",     "05", "", "")
call <sid>hi("sassMixinName",  "04", "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        "07", "", "")
call <sid>hi("javaScriptBraces",  "07", "", "")
call <sid>hi("javaScriptNumber",  "09", "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              "02", "", "")
call <sid>hi("markdownCodeBlock",         "02", "", "")
call <sid>hi("markdownHeadingDelimiter",  "04", "", "")

" Git highlighting
call <sid>hi("gitCommitOverflow",  "01", "", "")
call <sid>hi("gitCommitSummary",   "02", "", "")
  
" GitGutter highlighting
call <sid>hi("GitGutterAdd",     "02", "10", "")
call <sid>hi("GitGutterChange",  "04", "10", "")
call <sid>hi("GitGutterDelete",  "01", "10", "")
call <sid>hi("GitGutterChangeDelete",  "05", "10", "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     "02", "10", "")
call <sid>hi("SignifySignChange",  "04", "10", "")
call <sid>hi("SignifySignDelete",  "01", "10", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  "04", "", "")
call <sid>hi("NERDTreeExecFile",  "07", "", "")

" Remove functions
delf <sid>hi
