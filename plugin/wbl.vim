if exists("g:loaded_wbl")
  finish
endif
let g:loaded_wbl = 1

call wbl#init()

augroup ag_wbl
  autocmd!
  autocmd BufEnter *   call wbl#push(bufnr('%'))
  autocmd WinEnter *   call wbl#push(bufnr('%'))
augroup END

