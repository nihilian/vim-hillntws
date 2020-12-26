""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copyright (C) 2020 Benjamin Allred <nihilian@live.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 2 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <https://www.gnu.org/licenses/>.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Maintainer: Benjamin Allred <https://github.com/nihilian>
"
" Highlight trailing whitespace and lines longer than 80 characters.
" Inspired by code from:
"
" https://github.com/llvm/llvm-project/blob/master/llvm/utils/vim/vimrc
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable automatic highlighting for new help windows.
if !(exists('g:hillntws_noload') && g:hillntws_noload)
  call hillntws#FTNoAutoStart()
endif
