"======================================================
" Window Buffer List
"======================================================
"if v:version < 802
"  finish
"endif

if exists("g:loaded_wbl")
  finish
endif
let g:loaded_wbl = 1

"------------------------------------------------------
" public func
"------------------------------------------------------
func WblPush(bufnr)
  call wbl#WblPush(a:bufnr)
endfunc

func WblPop()
  call wbl#WblPop()
endfunc

func WblNext()
  call wbl#WblNext()
endfunc

func WblPrev()
  call wbl#WblPrev()
endfunc

func WblPrint()
  call wbl#WblPrint()
endfunc

"------------------------------------------------------
" autocmd
"------------------------------------------------------
augroup ag_wbl
  autocmd!
  autocmd BufEnter *   call wbl#WblPush(bufnr('%'))
  autocmd WinEnter *   call wbl#WblPush(bufnr('%'))
augroup END

"------------------------------------------------------
" init
"------------------------------------------------------
call wbl#WblInit()
