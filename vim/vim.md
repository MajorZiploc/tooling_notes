
# Git 
## diff the split screen files you have open in vim

`:windo :diffthis`


# History
## search history of commands run in vim with one of the following:

in normal mode:

`q:`

brings up a list of the commands in normal mode and then press enter on the one you want


## show history of commands

`:his[tory]`

# Syntax

## turn syntax highlighting off

`:syn off`

## turn syntax highlighting on

`:syn on`

## use a specific language syntax highlighting - tab completion to view choices

`:set filetype=<lang> :`

## in a file, you can specify a lang syntax highlighting to use if you write the following line in the file

`vim: set ft=<lang>`


## reset syntax highlighting if it messes up

`:syntax sync fromstart`

# Auto Compolete

## Show suggestions
in insert mode press `<ctrl>-p` || `<ctrl>-n` and it shows suggestions

https://stackoverflow.com/questions/54104/is-there-any-way-to-enable-code-completion-for-perl-in-vim

The standard `Ctrl+N` and `Ctrl+P` works even better if you add the following to your `~/.vim/ftplugin/perl.vim` file:

`set iskeyword+=:`

Then it will autocomplete module names, etc.


# Buffers

## List open buffers

`:ls`

## goto buffer based on id from `:ls`

`:b<n>` or `:b <n>`

Example: `:b1` to goto buffer with id of 1

## goto next buffer

`:n` or `:bn`

## goto prev buffer

`:N` or `:bp`

## remove a buffer from :ls listing and jump list

`:bwipeout`

## remove a buffer from :ls listing but not jump list

`:bdelete`


# Tabs

## open new tab specified directory or the file

`:tabedit <./path/to/dir/or/file>`

Example: `:tabedit .` to open current directory in new tab

Example: `:tabedit ./READEME.md` to open READEME in new tab

## cycle to next tab

`gt` in normal mode

## cycle to prev tab

`gN` in normal mode

## goto to nth tab

`<n>gt` in normal mode

Example: `3gt` will go to third tab

# Sessions

## save vim session, (will save a vim file)

`:mksession <session_name>.vim`

## open session

`vim -S <session_name>.vim`

# Language

## spellchecking (google iso language codes for all codes)

`:set spelllang=en_us`

`:set spell`

## some language codes

`en_us` => english

`fr_ch` => french

`de_de` => german


# Misc

## clear the search highlight from / searches
`:noh`

(start typing how a prev cmd started) -
press up arrow to get last command that matches it

---

## incrementing selected numbers in diff ways

- `g <ctrl-a>`
- `<ctrl-a>`

---

## show file stats
`<ctrl-g>`

## run the current file as a shell command. must save the file first.
`:!sh %`

---

## fix dos new lines
`:%s/\r/\r/g`

---


