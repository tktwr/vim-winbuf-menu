"------------------------------------------------------
" init
"------------------------------------------------------
func wbl#WblInit()
  " set defaults
  let s:wbl_key = "\<End>"
  let s:wbl_max = 10
  let s:wbl_help = 1
  let s:wbl_edit_func = "wbl#WblEdit"
  let s:separator = "────────────────────────────────────────────────────────────────"
  let s:help_text = "[CR:edit, 1-9:winnr, x:delete, c:copy, p:paste, C:clear, ?:help]"

  call wbl#WblSetting()
endfunc

func wbl#WblSetting()
  "------------------------------------------------------
  " aux funcs
  "------------------------------------------------------
  if exists("*bmk#BmkEdit")
    let s:wbl_edit_func = "bmk#BmkEdit"
  endif

  "------------------------------------------------------
  " user defined global variables
  "------------------------------------------------------
  if exists("g:wbl_key")
    let s:wbl_key = g:wbl_key
  endif

  if exists("g:wbl_max")
    let s:wbl_max = g:wbl_max
  endif
endfunc

"------------------------------------------------------
" private func
"------------------------------------------------------
func s:WblRemoveBufnr(lst, bufnr)
  let i = match(a:lst, a:bufnr)
  if i != -1
    call remove(a:lst, i)
  endif
endfunc

func s:WblTruncateList(lst, max)
  if (len(a:lst) > a:max)
    call remove(a:lst, a:max, -1)
  endif
endfunc

func s:WblFindIdxByName(lst, pattern)
  let idx = 0
  for i in a:lst
    let s = bufname(i)
    if (match(s, a:pattern) == 0)
      return idx
    endif
    let idx = idx + 1
  endfor
  return -1
endfunc

"------------------------------------------------------
" public func
"------------------------------------------------------
func wbl#WblFind(pattern, winnr)
  if a:winnr > 0
    exec a:winnr."wincmd w"
  endif

  let idx = s:WblFindIdxByName(w:buflist, a:pattern)
  if (idx != -1)
    exec w:buflist[idx]."b"
  endif
endfunc

func wbl#WblEdit(file, winnr)
  if a:winnr > 0
    exec a:winnr."wincmd w"
  endif
  exec "edit" a:file
endfunc

func wbl#WblPrint()
  call wbl#WblPopupMenu()
endfunc

func wbl#WblCopy()
  let s:buflist = w:buflist
endfunc

func wbl#WblPaste()
  let w:buflist += s:buflist
  call s:WblTruncateList(w:buflist, s:wbl_max)
endfunc

func wbl#WblClear()
  if !exists("w:buflist")
    return
  endif

  if (len(w:buflist) > 1)
    let bufnr = w:buflist[0]
    let w:buflist = [bufnr]
  endif
endfunc

func wbl#WblNew()
  enew
endfunc

func wbl#WblPush(bufnr)
  if !exists("w:buflist")
    let w:buflist = []
  endif

  call s:WblRemoveBufnr(w:buflist, a:bufnr)
  call insert(w:buflist, a:bufnr)
  call s:WblTruncateList(w:buflist, s:wbl_max)
endfunc

func wbl#WblPop()
  if len(w:buflist) == 1
    let bufnr = w:buflist[0]
    call wbl#WblNew()
    call wbl#WblPush(bufnr)
  endif

  if len(w:buflist) > 1
    call remove(w:buflist, 0)
    exec w:buflist[0]."b"
  endif
endfunc

func wbl#WblBufDelete(bufnr)
  if len(w:buflist) == 1
    let bufnr = w:buflist[0]
    call wbl#WblNew()
    call wbl#WblPush(bufnr)
  endif

  if len(w:buflist) > 1
    call s:WblRemoveBufnr(w:buflist, a:bufnr)
    exec w:buflist[0]."b"
    exec "bdelete" a:bufnr
  endif
endfunc

"------------------------------------------------------
func wbl#WblPrev()
  if !exists("w:buflist") || (len(w:buflist) <= 1)
    return
  endif

  let bufnr = w:buflist[0]
  call remove(w:buflist, 0)
  call add(w:buflist, bufnr)
  exec w:buflist[0]."b"
endfunc

func wbl#WblNext()
  if !exists("w:buflist") || (len(w:buflist) <= 1)
    return
  endif

  let bufnr = w:buflist[-1]
  call remove(w:buflist, -1)
  call insert(w:buflist, bufnr)
  exec w:buflist[0]."b"
endfunc

"------------------------------------------------------
" popup menu
"------------------------------------------------------
func wbl#filter(id, key)
  let w:dst_winnr = 0
  if a:key == s:wbl_key
    call popup_close(a:id, 0)
    return 1
  elseif a:key == "?"
    let s:wbl_help = 1 - s:wbl_help
    call popup_close(a:id, 0)
    call wbl#WblPopupMenu()
    return 1
  elseif a:key == "c"
    call popup_close(a:id, 0)
    call wbl#WblCopy()
    return 1
  elseif a:key == "p"
    call popup_close(a:id, 0)
    call wbl#WblPaste()
    return 1
  elseif a:key == "C"
    call popup_close(a:id, 0)
    call wbl#WblClear()
    return 1
  elseif a:key == "x"
    let w:dst_winnr = -1
    return popup_filter_menu(a:id, "\<CR>")
  elseif match(a:key, "[1-9]") == 0
    let w:dst_winnr = a:key + 0
    return popup_filter_menu(a:id, "\<CR>")
  endif
  return popup_filter_menu(a:id, a:key)
endfunc

"------------------------------------------------------
" vim 8.1
func wbl#handler(id, result)
  if a:result == 0
  elseif a:result > 0
    let idx = a:result - 1

    let bufnr = w:buflist[idx]
    if w:dst_winnr == 0
      exec bufnr."b"
    elseif w:dst_winnr == -1
      call wbl#WblBufDelete(bufnr)
    else
      let bufname = bufname(bufnr)
      let absname = fnamemodify(bufname, ":p")
      exec printf('call %s("%s", %d)', s:wbl_edit_func, absname, w:dst_winnr)
    endif
  endif
endfunc

" nvim
func wbl#handler_str(str)
  let bufnr = str2nr(a:str[0:2])
  exec bufnr."b"
endfunc

"------------------------------------------------------
func wbl#WblPopupMenu()
  if !exists("w:buflist")
    return
  endif

  let l = []
  for i in w:buflist
    let s = printf("%3d %s ", i, bufname(i))
    call add(l, s)
  endfor
  if s:wbl_help
    call add(l, s:separator)
    call add(l, s:help_text)
  endif

  let w:dst_winnr = 0

  let title = ' wbl '
  if exists('*popup_menu')
    " vim 8.1
    let winid = cpm#popup_menu#open(title, l, 'wbl#handler', 'wbl#filter')
  elseif has('nvim') && exists('g:loaded_popup_menu')
    " nvim with the plugin 'Ajnasz/vim-popup-menu'
    let winid = cpm#popup_menu#open(title, l, 'wbl#handler_str', '')
  endif
  call win_execute(winid, 'setl syntax=wbl')
  return winid
endfunc

