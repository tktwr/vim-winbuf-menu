# vim-winbuf-menu

vim-winbuf-menu is a pop-up menu for displaying a window-specific buffer list.

Requirements: Vim >= 8.1 or Neovim >= 0.4.3 (limited functionalities)

## Install

Install plugins using a plugin manager such as
[vim-plug](https://github.com/junegunn/vim-plug).

Install
[popup-menu.nvim](https://github.com/kamykn/popup-menu.nvim)
to support a popup menu in neovim.
~~~
if has('nvim')
  Plug 'kamykn/popup-menu.nvim'
endif
~~~

Install the plugin.
~~~
Plug 'tktwr/vim-winbuf-menu'
~~~

## Maps

~~~
nnoremap <silent> <End>  <C-W>:silent call WblPrint()<CR>
tnoremap <silent> <End>  <C-W>:silent call WblPrint()<CR>
~~~

