" Author:	Gergely Kontra <kgergely@mcl.hu>
" Version:	0.1
" Description:	Micro vim template file loader
" Installation:	Drop it into your plugin directory
" Usage:	Template file has some magic characters
"		- Strings surrounded by ¡ are expanded by vim
"		  Eg: ¡strftime('%c')¡ will be expanded to the current time
"		  (the time, when the template is read), so
"		  2002.02.20. 14:49:23 on my system NOW.
"		- Strings between «» signs are fill-out places, or marks, if
"		  you are familiar with some bracketing or jumping macros
"
" History:	0.1	Initial release
" BUGS:		First mark must contain text
"		Globals should be prefixed. Eg.: g:author 
" TODO:		Re-executing commands. (Can be useful for Last Modified
"		fields)
if !exists('$VIMTEMPLATES')
  let $VIMTEMPLATES=$VIM.'/vimfiles/template'
en
if !strlen(maparg('¡jump!','n')) " if you don't have bracketing macros
  fu! Jumpfunc()
    if !search('«.\{-}»','W') "no more marks
      retu "\<CR>"
    el
      if getline('.')[col('.')]=="»"
	retu "\<Del>\<Del>"
      el
	retu "\<Esc>lvf»\<C-g>"
      en
    en
  endf
  imap ¡jump! <c-r>=Jumpfunc()<CR>
  nmap <C-J> i¡jump!
  imap <C-J> ¡jump!
  vmap <C-J> <Del><C-J>
en

fu! <SID>Exec(what)
  exe 'retu' a:what
endf

fu! <SID>Template()
  let ft=strlen(&ft)?&ft:'unknown'
  if filewritable($VIMTEMPLATES.'/template.'.ft)==1
    exe '0r $VIM/vimfiles/template/template.'.ft
    %s/¡\([^¡]*\)¡/\=<SID>Exec(submatch(1))/ge
    0
    exe "norm \<C-J>"
  en
endf

augroup template
au BufNewFile * cal <SID>Template()
au BufWritePre * echon 'TODO'
augroup END
