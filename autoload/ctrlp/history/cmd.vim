" Filters cmd history and executes selected command.
"
if exists('g:loaded_ctrlp_history_cmd') && g:loaded_ctrlp_history_cmd
  finish
endif
let g:loaded_ctrlp_history_cmd = 1

let s:history_cmd_var = {
            \ 'init': 'ctrlp#history#cmd#init()',
            \ 'exit': 'ctrlp#history#cmd#exit()',
            \ 'accept': 'ctrlp#history#cmd#accept',
            \ 'lname': 'history_cmd',
            \ 'sname': 'history_cmd',
            \ 'type': 'history_cmd',
            \ 'sort': 0,
            \ 'opmul': 1,
            \ 'wipe': 'ctrlp#history#cmd#wipe',
            \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:history_cmd_var)
else
    let g:ctrlp_ext_vars = [s:history_cmd_var]
endif

function! s:get_candidates() abort
    redir => hist
    silent history
    redir END
    let arranged_hist = []
    for h in split(hist,"\n")[1:]
        call add(arranged_hist,matchlist(h,'\s*\d\+\s*\(.*\)')[1])
    endfor
    return arranged_hist
endfunction

function! ctrlp#history#cmd#init()
    return reverse(s:get_candidates())
endfunc

function! ctrlp#history#cmd#accept(mode, str)
    call ctrlp#exit()
    call histadd("cmd",a:str)
    exec a:str
endfunction

function! ctrlp#history#cmd#exit()
endfunction

function! ctrlp#history#cmd#wipe(entries)
    if empty(a:entries)
        call histdel('cmd')
    else
        for entry in a:entries
            call histdel('cmd', '\V\^'.escape(entry, '\').'\$')
        endfor
    endif
    return reverse(s:get_candidates())
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#history#cmd#id()
    return s:id
endfunction
