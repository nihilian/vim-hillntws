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

" Setting `g:hillntws_noload` before this plugin is loaded (e.g. vimrc) will
" disable it from loading altogether. Using a version of Vim older than 7.2
" is not supported.
if v:version < 702
  let g:hillntws_noload = 1
endif

if !((exists('g:hillntws_noload') && g:hillntws_noload)
  \ || exists('g:loaded_hillntws'))

  let g:loaded_hillntws = 1
  " Minimum length of what to consider a `LongLine` (default is 80 columns).
  " Can set `g:hillntws_lnlen` to any value that is a valid column number.
  if !exists('g:hillntws_lnlen')
    let g:hillntws_lnlen = 80
  endif

  " The `LongLine` and `WhitespaceEOL` highlight groups are given default
  " values (dark yellow background) for the active mode (cterm or gui) only
  " if no such value had been defined before loading this plugin.
  if synIDattr(hlID('LongLine'), 'bg') == ''
    highlight LongLine ctermbg=3 guibg=DarkYellow
  endif
  if synIDattr(hlID('WhitespaceEOL'), 'bg') == ''
    highlight WhitespaceEOL ctermbg=3 guibg=DarkYellow
  endif

  augroup HiLongAndWsEOL
    autocmd!
    " Filetype is required for initialization to complete. Files with an
    " unknown type can still be manually toggled on using the
    " `ToggleHiLongAndWsEOL` command below.
    autocmd FileType * call hillntws#FTDetected()

    " Initialize new windows by determining whether or not they should start
    " highlighted. Match highlight groups to window's current state.
    autocmd BufEnter * call hillntws#MatchDefault()

    " Suppress whitespace highlighting while a line is being typed.
    autocmd InsertEnter * call hillntws#SetSmartWsEOL(1)

    " Then revert back to normal whitespace highlighting.
    autocmd InsertLeave * call hillntws#SetSmartWsEOL(0)
  augroup END

  " Command to toggle highlighting in the current window.
  if !exists(':HiLongLnAndTrailingWs')
    command HiLongLnAndTrailingWs call hillntws#ToggleHi()
  endif

  " Can also map to `<Plug>HiLLnTWsToggle` (default is `<Leader>H`).
  if !hasmapto('<Plug>HiLLnTWsToggle')
    map <unique> <Leader>H <Plug>HiLLnTWsToggle
  endif
  noremap <unique> <silent> <Plug>HiLLnTWsToggle :call hillntws#ToggleHi()<CR>

endif
