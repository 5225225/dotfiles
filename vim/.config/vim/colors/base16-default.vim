" Base16 Default (https://github.com/chriskempson/base16)
" Scheme: Chris Kempson (http://chriskempson.com)

" Terminal color definitions
let s:cterm00 = "00"
let s:cterm03 = "08"
let s:cterm05 = "07"
let s:cterm07 = "15"
let s:cterm08 = "01"
let s:cterm0A = "03"
let s:cterm0B = "02"
let s:cterm0C = "06"
let s:cterm0D = "04"
let s:cterm0E = "05"
if exists('base16colorspace') && base16colorspace == "256"
  let s:cterm01 = "18"
  let s:cterm02 = "19"
  let s:cterm04 = "20"
  let s:cterm06 = "21"
  let s:cterm09 = "16"
  let s:cterm0F = "17"
else
  let s:cterm01 = "10"
  let s:cterm02 = "11"
  let s:cterm04 = "12"
  let s:cterm06 = "13"
  let s:cterm09 = "09"
  let s:cterm0F = "14"
endif

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
call <sid>hi("Debug",         s:cterm08, "", "")
call <sid>hi("Directory",     s:cterm0D, "", "")
call <sid>hi("ErrorMsg",      s:cterm08, s:cterm00, "")
call <sid>hi("Exception",     s:cterm08, "", "")
call <sid>hi("FoldColumn",    "", s:cterm01, "")
call <sid>hi("Folded",        s:cterm03, s:cterm01, "")
call <sid>hi("IncSearch",     s:cterm01, s:cterm09, "none")
call <sid>hi("Italic",        "", "", "none")
call <sid>hi("Macro",         s:cterm08, "", "")
call <sid>hi("MatchParen",    s:cterm00, s:cterm03,  "")
call <sid>hi("ModeMsg",       s:cterm0B, "", "")
call <sid>hi("MoreMsg",       s:cterm0B, "", "")
call <sid>hi("Question",      s:cterm0A, "", "")
call <sid>hi("Search",        s:cterm03, s:cterm0A,  "")
call <sid>hi("SpecialKey",    s:cterm03, "", "")
call <sid>hi("TooLong",       s:cterm08, "", "")
call <sid>hi("Underlined",    s:cterm08, "", "")
call <sid>hi("Visual",        "", s:cterm03, "")
call <sid>hi("VisualNOS",     s:cterm08, "", "")
call <sid>hi("WarningMsg",    s:cterm08, "", "")
call <sid>hi("WildMenu",      s:cterm08, "", "")
call <sid>hi("Title",         s:cterm0D, "", "none")
call <sid>hi("Conceal",       s:cterm0D, s:cterm00, "")
call <sid>hi("Cursor",        s:cterm00, s:cterm05, "")
call <sid>hi("NonText",       s:cterm03, "", "")
call <sid>hi("Normal",        s:cterm05, "", "")
call <sid>hi("LineNr",        s:cterm03, "", "bold")
call <sid>hi("SignColumn",    s:cterm03, s:cterm01, "")
call <sid>hi("SpecialKey",    s:cterm03, "", "")
call <sid>hi("StatusLine",    s:cterm00, "", "bold")
call <sid>hi("StatusLineNC",  s:cterm03, s:cterm01, "none")
call <sid>hi("VertSplit",     s:cterm02, "", "none")
call <sid>hi("ColorColumn",   "", s:cterm01, "none")
call <sid>hi("CursorColumn",  "", s:cterm01, "none")
call <sid>hi("CursorLine",    "", s:cterm01, "none")
call <sid>hi("CursorLineNr",  s:cterm03, "none", "bold")
call <sid>hi("PMenu",         s:cterm04, s:cterm01, "none")
call <sid>hi("PMenuSel",      s:cterm01, s:cterm04, "")
call <sid>hi("TabLine",       s:cterm03, s:cterm01, "none")
call <sid>hi("TabLineFill",   s:cterm03, s:cterm01, "none")
call <sid>hi("TabLineSel",    s:cterm0B, s:cterm01, "none")

" Standard syntax highlighting
call <sid>hi("Boolean",      s:cterm09, "", "")
call <sid>hi("Character",    s:cterm08, "", "")
call <sid>hi("Comment",      s:cterm03, "", "")
call <sid>hi("Conditional",  s:cterm0E, "", "")
call <sid>hi("Constant",     s:cterm09, "", "")
call <sid>hi("Define",       s:cterm0E, "", "none")
call <sid>hi("Delimiter",    s:cterm0F, "", "")
call <sid>hi("Float",        s:cterm09, "", "")
call <sid>hi("Function",     s:cterm0D, "", "")
call <sid>hi("Identifier",   s:cterm08, "", "none")
call <sid>hi("Include",      s:cterm0D, "", "")
call <sid>hi("Keyword",      s:cterm0E, "", "")
call <sid>hi("Label",        s:cterm0A, "", "")
call <sid>hi("Number",       s:cterm09, "", "")
call <sid>hi("Operator",     s:cterm05, "", "none")
call <sid>hi("PreProc",      s:cterm0A, "", "")
call <sid>hi("Repeat",       s:cterm0A, "", "")
call <sid>hi("Special",      s:cterm0C, "", "")
call <sid>hi("SpecialChar",  s:cterm0F, "", "")
call <sid>hi("Statement",    s:cterm08, "", "")
call <sid>hi("StorageClass", s:cterm0A, "", "")
call <sid>hi("String",       s:cterm0B, "", "")
call <sid>hi("Structure",    s:cterm0E, "", "")
call <sid>hi("Tag",          s:cterm0A, "", "")
call <sid>hi("Todo",         s:cterm0A, s:cterm01, "")
call <sid>hi("Type",         s:cterm09, "", "none")
call <sid>hi("Typedef",      s:cterm0A, "", "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", s:cterm00, "undercurl")
call <sid>hi("SpellLocal",   "", s:cterm00, "undercurl")
call <sid>hi("SpellCap",     "", s:cterm00, "undercurl")
call <sid>hi("SpellRare",    "", s:cterm00, "undercurl")

" Additional diff highlighting
call <sid>hi("DiffAdd",      s:cterm0B, s:cterm00, "")
call <sid>hi("DiffChange",   s:cterm0D, s:cterm00, "")
call <sid>hi("DiffDelete",   s:cterm08, s:cterm00, "")
call <sid>hi("DiffText",     s:cterm0D, s:cterm00, "")
call <sid>hi("DiffAdded",    s:cterm0B, s:cterm00, "")
call <sid>hi("DiffFile",     s:cterm08, s:cterm00, "")
call <sid>hi("DiffNewFile",  s:cterm0B, s:cterm00, "")
call <sid>hi("DiffLine",     s:cterm0D, s:cterm00, "")
call <sid>hi("DiffRemoved",  s:cterm08, s:cterm00, "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:cterm0D, "", "")
call <sid>hi("rubyConstant",                s:cterm0A, "", "")
call <sid>hi("rubyInterpolation",           s:cterm0B, "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:cterm0F, "", "")
call <sid>hi("rubyRegexp",                  s:cterm0C, "", "")
call <sid>hi("rubySymbol",                  s:cterm0B, "", "")
call <sid>hi("rubyStringDelimiter",         s:cterm0B, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:cterm05, "", "")
call <sid>hi("phpComparison",      s:cterm05, "", "")
call <sid>hi("phpParent",          s:cterm05, "", "")

" HTML highlighting
call <sid>hi("htmlBold",    s:cterm0A, "", "")
call <sid>hi("htmlItalic",  s:cterm0E, "", "")
call <sid>hi("htmlEndTag",  s:cterm05, "", "")
call <sid>hi("htmlTag",     s:cterm05, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:cterm05, "", "")
call <sid>hi("cssClassName",   s:cterm0E, "", "")
call <sid>hi("cssColor",       s:cterm0C, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:cterm08, "", "")
call <sid>hi("sassClassChar",  s:cterm09, "", "")
call <sid>hi("sassInclude",    s:cterm0E, "", "")
call <sid>hi("sassMixing",     s:cterm0E, "", "")
call <sid>hi("sassMixinName",  s:cterm0D, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:cterm05, "", "")
call <sid>hi("javaScriptBraces",  s:cterm05, "", "")
call <sid>hi("javaScriptNumber",  s:cterm09, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:cterm0B, "", "")
call <sid>hi("markdownCodeBlock",         s:cterm0B, "", "")
call <sid>hi("markdownHeadingDelimiter",  s:cterm0D, "", "")

" Git highlighting
call <sid>hi("gitCommitOverflow",  s:cterm08, "", "")
call <sid>hi("gitCommitSummary",   s:cterm0B, "", "")
  
" GitGutter highlighting
call <sid>hi("GitGutterAdd",     s:cterm0B, s:cterm01, "")
call <sid>hi("GitGutterChange",  s:cterm0D, s:cterm01, "")
call <sid>hi("GitGutterDelete",  s:cterm08, s:cterm01, "")
call <sid>hi("GitGutterChangeDelete",  s:cterm0E, s:cterm01, "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     s:cterm0B, s:cterm01, "")
call <sid>hi("SignifySignChange",  s:cterm0D, s:cterm01, "")
call <sid>hi("SignifySignDelete",  s:cterm08, s:cterm01, "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:cterm0D, "", "")
call <sid>hi("NERDTreeExecFile",  s:cterm05, "", "")

" Remove functions
delf <sid>hi
