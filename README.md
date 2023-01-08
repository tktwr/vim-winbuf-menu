# vim-winbuf-menu

vim-winbuf-menu is a pop-up menu for displaying a window-specific buffer list.

Requirements: Vim >= 8.1 or Neovim >= 0.4.3 (limited functionalities)

## Install

Install plugins using a plugin manager such as
[vim-plug](https://github.com/junegunn/vim-plug).

Install
[vim-popup-menu](https://github.com/Ajnasz/vim-popup-menu)
to support a popup menu in neovim.
~~~
if has('nvim')
  Plug 'Ajnasz/vim-popup-menu'
endif
~~~

Install the plugin.
~~~
Plug 'tktwr/vim-winbuf-menu'
~~~

## Maps

~~~
nnoremap <silent> <End>  <C-W>:silent call wbl#open()<CR>
tnoremap <silent> <End>  <C-W>:silent call wbl#open()<CR>
~~~

