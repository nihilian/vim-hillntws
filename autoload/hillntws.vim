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

function s:MatchLongLine()
  return matchadd('LongLine', '\%>' . g:hillntws_lnlen . 'v.\+', -1)
endfunction

function s:MatchWhitespaceEOL()
  return matchadd('WhitespaceEOL', '\s\+$', -1)
endfunction

function s:MatchSmartWhitespaceEOL()
  return matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
endfunction

" Toggle excluding `WhitespaceEOL` from the line currently being edited in
" Insert mode. This allows <Space> and <Tab> characters to be typed and not be
" instantly highlighted as trailing whitespace. Should only be called in
" response to the `InsertEnter` and `InsertLeave` events.
function hillntws#SetSmartWsEOL(enable)
  if exists('b:hillntws_enabled') && b:hillntws_enabled
    if exists('w:m1')
      call matchdelete(w:m1)
    endif
    let w:m1 = a:enable ? s:MatchSmartWhitespaceEOL()
                      \ : s:MatchWhitespaceEOL()
  endif
endfunction

" Match `LongLine` and `WhitespaceEOL` to the current window state. Should
" only be called in response to the `BufWinEnter` event or at the end of
" window initialization.
function hillntws#MatchDefault()
  if exists('w:m0')
    call matchdelete(w:m0)
    unlet w:m0
  endif
  if exists('w:m1')
    call matchdelete(w:m1)
    unlet w:m1
  endif

  if exists('b:hillntws_enabled') && b:hillntws_enabled
    let w:m0 = s:MatchLongLine()
    let w:m1 = s:MatchWhitespaceEOL()
  endif
endfunction

" Toggle highlighting for the current window. Overrides the filetype-dependent
" autostart functionality, and can be called through a command or mapping.
function hillntws#ToggleHi()
  if !exists('b:hillntws_enabled')
    let b:hillntws_enabled = 1
  else
    let b:hillntws_enabled = !b:hillntws_enabled
  endif
  call hillntws#MatchDefault()
endfunction

" Don't highlight new windows onload for the value set to the filetype option.
" This function is intended to be called by a ftplugin.
function hillntws#FTNoAutoStart()
  if &filetype != ''
    execute 'let s:noautohi_' . &filetype . ' = 1'
    call hillntws#FTDetected()
  endif
endfunction

" Called when filetype is detected. If this is a new window it will be
" initialized provided the filetype isn't listed as `NoAutoStart`, and that
" the `BufWinEnter` event is triggered.
function hillntws#FTDetected()
  if !(exists('b:hillntws_enabled') || exists('s:noautohi_' . &filetype))
    let b:hillntws_enabled = 1
  endif
  call hillntws#MatchDefault()
endfunction
