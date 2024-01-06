# vim-grepo
Equivalent of `grep -o` in vim.

## Installation

    mkdir -p ~/.vim/pack/grepo/start/grepo/
    cd ~/.vim/pack/grepo/start/grepo/
    git clone https://github.com/christian-proust/vim-grepo.git .

## Usage

Both function and command Grepo take an optional argument opts.

If opts contains 'l': the result will be written in location list.
If opts contains 'p': the result will be printed.
If opts contains 'u': only the uniq values are kept.
If opts contains 's': values are sorted.

'u' implies 's'
If neither 'l' or 'p' are given, the result will be written in a new draft buffer.

## Example

* Given the following text in `example.txt`:

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum pulvinar
    aliquam viverra. Aenean accumsan et neque ac hendrerit.
    
    Suspendisse tincidunt congue bibendum. Duis egestas tempor feugiat. 
    Curabitur egestas nunc nisi, id tristique libero finibus et. 
    
    Pellentesque lacus ex, molestie eget neque eget, ullamcorper gravida quam. 
    In rutrum et lectus luctus faucibus. In sollicitudin rutrum accumsan. Sed 
    quis libero viverra, dignissim metus vehicula, viverra urna. Proin sed diam 
    pellentesque, dictum tortor eget, sollicitudin eros.

* Open `example.txt` with vim.
* Search for every words ending with um: `/\w\+um\>`
* Type `:Grepo p` and you will see: `['ipsum', 'Vestibulum', 'bibendum', 'rutrum', 'rutrum', 'dictum']`.
* Type `:Grepo pu` and you will see: `['Vestibulum', 'bibendum', 'dictum', 'ipsum', 'rutrum']`.
* Type `:Grepo lu` and `:lopen` to see the same in the location list.
* Type `:Grepo u` to see the same into a new Draft buffer.
