function! Grepo(...)
    " First optional argument: opts
    " If opts contains 'l': the result will be written in location list.
    " If opts contains 'p': the result will be printed.
    " If opts contains 'u': only the uniq values are kept.
    " If opts contains 's': values are sorted.
    "
    " u implies s
    let opts = get(a:, 1, '')

    " Store the init_pos in order to come back to it at the end
    let init_pos = getcurpos()
    " lines will contains the list of dict.
    " See `:h setqflist` in order to understand the key of the dict.
    let lines = []

    " Go at the end of the file
    normal G$

    " loop tells if we should continue the processing
    " we will call search multiple times.
    " - Without and with 'e' option to get the first and the last position of
    " the match item.
    " - Except for the first search, the search won't loop at the end of the
    "   file (option 'W').
    "
    " The start_pos and end_pos will be used to extract the text of the
    " searched items.
    let loop = search(@/)

    while loop
        let start_pos = getcurpos()
        if search(@/, 'eW')
            let end_pos = getcurpos()
            let line = getline(start_pos[1], end_pos[1])
            let line[-1] = line[-1][:end_pos[2]-1]
            let line[0] = line[0][start_pos[2]-1:]
            let lines += [#{
            \    bufnr: bufnr(),
            \    lnum: start_pos[1],
            \    end_lnum: end_pos[1],
            \    pattern: @/,
            \    col: start_pos[2],
            \    end_col: start_pos[2],
            \    text: line->join("\n")}]
        endif
        let loop = search(@/, 'W')
    endwhile
    call setpos('.', init_pos)

    " Based on the options, call sort() or uniq() method
    if stridx(opts, 's') >= 0 || stridx(opts, 'u') >= 0
        eval lines->sort({
        \  x, y -> (
        \   (x.text == y.text)? (
        \   (x.lnum == y.lnum)? (
        \   (x.col  == y.col )? (
        \       0
        \   ): (x.col  > y.col )? 1:-1
        \   ): (x.lnum > y.lnum)? 1:-1
        \   ): (x.text > y.text)? 1:-1
        \ )})
    endif
    if stridx(opts, 'u') >= 0
        eval lines->uniq({x, y -> (x.text == y.text)? 0:1})
    endif

    " Based on options, output either in the local list window, print the
    " output or put it in a new buffer.
    if stridx(opts, 'l') >= 0
        call setloclist(0, lines, "r")
    elseif stridx(opts, 'p') >= 0
        echo map(lines, 'v:val.text')
    else
        new
        setlocal buftype=nofile
        call append(0, map(lines, 'v:val.text'))
        normal "_dd
    endif
endfunction


command! -narg=? Grepo call Grepo(<q-args>)
