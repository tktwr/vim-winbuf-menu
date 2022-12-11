" Vim syntax file
" Language: wbl

"------------------------------------------------------
" syntax
"------------------------------------------------------
syn clear
" syntax is case sensitive
syn case match

syn match    wblBufNr            '^ \+\d\+ '
syn match    wblSeparator        '^─\+$'
syn match    wblKey              '[0-9A-Za-z_\-?]\+:' contained
syn match    wblHelp             '\[[^]]*\]' contains=wblKey

"------------------------------------------------------
" highlight
"------------------------------------------------------
hi WblRed           ctermfg=167 guifg=#fb4934
hi WblGreen         ctermfg=142 guifg=#b8bb26
hi WblYellow        ctermfg=214 guifg=#fabd2f
hi WblBlue          ctermfg=109 guifg=#707fd9
hi WblPurple        ctermfg=175 guifg=#d3869b
hi WblAqua          ctermfg=108 guifg=#8ec07c
hi WblOrange        ctermfg=208 guifg=#fe8019

hi WblGray          ctermfg=245 guifg=#928374
hi WblBg2           ctermfg=239 guifg=#504945

"------------------------------------------------------
" highlight link
"------------------------------------------------------
hi link wblSeparator        WblBg2
hi link wblBufNr            WblRed
hi link wblKey              WblYellow
hi link wblHelp             WblGray
