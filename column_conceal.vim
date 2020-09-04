" Stuff to manage some syntax magic to nicely display tab-separated files by
" truncating their cells.

" boolean flag: is concealment active?
let g:column_conceal = 0
" number of characters to show
let g:column_cell_truncate_width = '8'
" column separator
let g:column_sep_char = '\t'

function! DoColumnTruncateRefresh() abort
    exec 'syntax match ColumnCell "[^' . g:column_sep_char
        \ . ']\{' . g:column_cell_truncate_width . '}\zs[^'
        \ . g:column_sep_char . ']*[' . g:column_sep_char .
        \ '\n]" conceal cchar=|'
endfunction

call DoColumnTruncateRefresh()

function! ColumnTruncateRefresh() abort
    syntax clear ColumnCell
    call DoColumnTruncateRefresh()
endfunction

function! ToggleColumnTruncate() abort
    call ColumnTruncateRefresh()
    if g:column_conceal
        set conceallevel=0
    else
        set conceallevel=1
    endif
    let g:column_conceal = !g:column_conceal
endfunction

function! IncrementColumnTruncateWidth() abort
    let g:column_cell_truncate_width += 1
    call ColumnTruncateRefresh()
endfunction

function! DecrementColumnTruncateWidth() abort
    if g:column_cell_truncate_width > 1
        let g:column_cell_truncate_width -= 1
        call ColumnTruncateRefresh()
    endif
endfunction

function! SetColumnTruncateWidth() abort
    let g:column_cell_truncate_width = inputdialog(
            \ "Set truncation width to: ", "", g:column_cell_truncate_width)
    if g:column_cell_truncate_width !~? '^[1-9]\+[0-9]*$'
        echohl ErrorMsg
        redraw | echomsg "invalid value " .
            \ g:column_cell_truncate_width . ", setting to 8"
        echohl None
        let g:column_cell_truncate_width = '8'
    endif
    call ColumnTruncateRefresh()
endfunction

function! ToggleConcealCursorN() abort
    if &concealcursor =~ 'n'
        set concealcursor-=n
    else
        set concealcursor+=n
    endif
endfunction

function! ToggleCommaSeparated() abort
    if g:column_sep_char == '\t'
        let g:column_sep_char = ','
    else
        let g:column_sep_char = '\t'
    endif
    call ColumnTruncateRefresh()
endfunction

function! GetTableColumn() abort
    let line = getline(".")[:col(".") - 1][:-2]
    if g:column_sep_char == '\t'
        return count(line, "\<Tab>") + 1
    else
        return count(line, ",") + 1
    endif
endfunction

set ruler
set rulerformat=tab:%{GetTableColumn()},l:%l,c:%c
set concealcursor=nc

nnoremap yoc :call ToggleConcealCursorN()<CR>

nmap y> :call IncrementColumnTruncateWidth()<CR><SID>(>mode)
nmap y< :call DecrementColumnTruncateWidth()<CR><SID>(>mode)
nnoremap <script> <SID>(>mode)> :call IncrementColumnTruncateWidth()<CR><SID>(>mode)
nnoremap <script> <SID>(>mode)< :call DecrementColumnTruncateWidth()<CR><SID>(>mode)
nmap <script> <SID>(>mode) <Nop>

nnoremap yo<Tab> :call ToggleColumnTruncate()<CR>
" Previous solution kept for historical interest
" exec 'nnoremap yox :let g:column_cell_truncate_width =' .
"     \ '  <bar> call ColumnTruncateRefresh()' . repeat('<Left>', 31)
nnoremap yox :call SetColumnTruncateWidth()<CR>
nnoremap yo, :call ToggleCommaSeparated()<CR>
