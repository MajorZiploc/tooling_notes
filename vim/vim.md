# Git
## diff the split screen files you have open in vim

`:windo :diffthis`

# normal mode into insert mode
go to the beginning of a selection of text
I
go to the ending of a selection of text
A

# toggle cursor in visual mode to top or bottom of selection
o

# History
## search history of commands run in vim with one of the following:

# Search in file

## Search basic
`/`

## special classes
Case insensitive
\c
Case sensitive
\C
Word boundaries (\b)
\<search_phrase\>
Advanced regex (very magic mode)
\v
search history
q/

# Search in file

## Search basic but go 10 lines after the search phrase
`/phrase/+10`

## Search basic but go 10 lines before the search phrase
`/phrase/-10`

in normal mode:

command history (can also act as a standard vim buffer to work on commands to this execute with <cr>)
`q:`

search history (can also act as a standard vim buffer to work on commands to this execute with <cr>)
`q/`

brings up a list of the commands in normal mode and then press enter on the one you want


## show history of commands

`:his[tory]`

## search command history

(start typing how a prev cmd started) -
press up arrow to get last command that matches it

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

# Auto Complete

## Show suggestions
in insert mode press `<ctrl>-p` || `<ctrl>-n` and it shows suggestions

https://stackoverflow.com/questions/54104/is-there-any-way-to-enable-code-completion-for-perl-in-vim

The standard `<ctrl>+n` and `<ctrl>+p` works even better if you add the following to your `~/.vim/ftplugin/perl.vim` file:

`set iskeyword+=:`

Then it will autocomplete module names, etc.

## Accept suggestion
`<ctrl>+y`

## shift page by 1 line up
in normal mode:

`<ctrl>+y`

## shift page by 1 line down
in normal mode:

`<ctrl>+e`

# Buffers

## List open buffers

`:ls`

## goto buffer based on id from `:ls`

`:b<n>` or `:b <n>`

Example: `:b1` to goto buffer with id of 1

## goto next buffer

`:n` or `:bn` or `:cn`

## goto prev buffer

`:N` or `:bp` or `:cn`

## list c buffer things

`:cl`

## go to n c buffer thing (2 in this case)

`:cc2`

## view jump list

`:jumps`

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

`gN || gT` in normal mode

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

## turn off spellchecking
`:set nospell`

## spellchecking view list of alternative spellings for word under cursor
z=
followed by selecting the number the word you want to use is or just enter for no selection

## some language codes

`en_us` => english

`fr_ch` => french

`de_de` => german


# Misc

## clear the search highlight from / searches
`:noh`

---

## incrementing selected numbers in diff ways

- `g <ctrl-a>`
- `<ctrl-a>`

## decrementing selected numbers in diff ways

- `g <ctrl-x>`
- `<ctrl-x>`

---

## show file stats
`<ctrl-g>`

## run the current file as a shell command. must save the file first.
`:!sh %`

---

## fix dos new lines
`:%s/\r/\r/g`

---

# Explorer (Netrw)

## go into directory or open file
`<enter>`
or
`<ctrl>-m`

## preview file
cursor over a file and press `p`
<c-w>+z to close (or <c-w>+o if the preview window is the only other window)


# Checking for Problems in n?vim

`:checkhealth`

`:checkhealth provider`

## generate errors logs (and stall logs so you can read them on start) and store in fil myVim.log
vim -V9myVim.log

## Can solve plugin problems:
`:UpdateRemotePlugins`

# Reload ~/.vimrc by typing any one of the following command:

```
  :so $MYVIMRC
  # OR
  :source ~/.vimrc
```

# Python

## sort imports with help of bash command

isort can accept stdin with ... | sort -

in vim - visual select the imports -> ':! sort -' <CR> and the imports are sorted

# command splits

:horizontal topleft Git

:vertical rightbelow Git

See :h vertical and :h rightbelow

# make vim splits equal in size

<ctrl-w> + =


# view vim signs

:sign list

# navigate change list
g,
g;
:changes

# filter :ls
:filter /search_phrase/ :ls

# search and replace with quickfix list, telescope, and cfdo
to search/replace on all files, search and add them to the quickfixlist (ctrl+q in the live grep telescope windows), and then use `cfdo %s/a/b/g`, and finally `:wall` to save all changes :)

# get value of vim/lua fn calls
:echo <thing>
Example
:echo stdpath("data")


# fuzzy finding and finding things in general
search files
:find <glob_filename_pattern>
limit a search to a specific folder
:find ./start/with/exact_or_relative/path/can/have/*/later

search buffers
:ls
:b <substring_of_filename>


# ctags

create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

- Use <ctrl>] to jump to tag under cursor
- Use g<ctrl>] for ambiguous tags
    (can sometimes be g] . is the case in lvim)
- Use <ctrl>t to jump back up the tag stack

only tag python files
ctags --languages=python

## nav a g] list

- :ts or :tselect shows the list
- :tn or :tnext goes to the next tag in that list
- :tp or :tprev goes to the previous tag in that list
- :tf or :tfirst goes to the first tag of the list
- :tl or :tlast goes to the last tag of the list


# show current file
:echo expand("%")
or
"%p

# append the output of a bash command (ls) to your buffer
:r! ls


# Execute psql commands straight in vim
1. set the env vars for psql while in vim:
let $PGHOST="127.0.0.1" | let $PGPORT="5435" | let $PGDATABASE="database_name" | let $PGUSER="user" | let $PGPASSWORD="password"
2. visual select the query you want to run
3. ! psql
This will replace the query with the result of the query. can you what ever psql flags you want

" find db that you want to replace the above PGDATABASE values with
psql -c "\l"
" or copy this and pipe to psql
\l

# autocomplete (no plugin)
** -- keywords in complete next
<ctrl>n
** -- keywords in complete previous
<ctrl>p
-- keywords in the current file
<ctrl>x <ctrl>n
-- keywords in the dictionary
<ctrl>x <ctrl>k
-- keywords in the thesaurus
<ctrl>x <ctrl>t
-- keywords in the current and included files
<ctrl>x <ctrl>i
** -- tags
<ctrl>x <ctrl>]
** -- file names
<ctrl>x <ctrl>f
-- definitions or macros
<ctrl>x <ctrl>d
** -- vim command-line (q:)
<ctrl>x <ctrl>v
-- user defined complettion
<ctrl>x <ctrl>u
-- omni completion
<ctrl>x <ctrl>o
-- complete on full lines of text in the file
<ctrl>x <ctrl>l
-- spelling suggestions
<ctrl>x s

# snippets

print out a html template
:read ~/.vim/.skeleton/html/blank.html<cr>
or (:-1read)

print out a react functional component template
:-1read ~/.vim/.skeleton/typescript/react/blank_fc.tsx<cr>

# help
:help <thing>
look up ctrl-n docs in insert mode
:help i_^n
grep help docs for phras
:helpgrep phrase
NOTE: cl, cn, cp can cycle through the occurrences of phrase in the help docs

# splits
Look into:
set splitbelow
set splitbelow!
set split*

# expr
c prefixed commands are global to the vim session
to load info into a quickfix list openned with :copen (:cw for short)
  cexpr - can iterate choices
  caddexpr

l prefixed commands are local to the current window
location (l)
  lexpr
  lopen
  lgrep - uses the same set gp as grep does

# globpath in place of :find to search hidden paths aswell
:horizontal topleft help globpath()
command! -nargs=1 FindHiddenFiles let files = globpath('.', '**/' . <q-args>, 1, 1) | if len(files) | execute 'edit ' . files[0] | endif

# folds

## major commands
" toggle current fold
za
" close fold (selected)
zc
" close all nested folds (selected)
zC
" close fold (whole file)
zm
" close all nested folds (whole file)
zM
" open fold (selected)
zo
" open all nested folds (selected)
zO
" reduce all fold levels by 1 (whole file)
zr
" opens all nested folds (whole file)
zR
" fold around a paragraph
zfap
" fold around a tag
zfat

## fold types

" folds must be defined by entering commands (like zf)
set foldmethod=manual

" creates a fold for each indent
set foldmethod=indent

" creates a fold by the syntax of a programming language
set foldmethod=syntax

" folds are created by a user-defined expression (like a regex)
set foldmethod=expr

" creates folds for start and end characters you define
set foldmethod=marker

" used to fold unchanged text when viewing differences (automatically set in diff mode)
set foldmethod=diff

# highlights (for transparency and colors)
-- NOTE: view highlights list through :highlight or :Telescope highlights

# autoindent
visual selection and then press `=`

:vimgrep /<search_phrase>/g <file_glob>

# redirection output of vim command (:ls in example) into a variable
let result = ""
redir => result
silent ls
redir END
" The variable 'result' now contains the output of ':ls' command.
echo result

# system calls
call shell commands with system('<command_here>') or systemlist('<command_here>')

# lua
call global lua fn and put into lvim keymap
lvim.keys.normal_mode["<leader>fg"] = ":lua live_grep_git_dir()<CR>"

print a lua result
:lua print(vim.fn.stdpath("data"))

set var and then print it
:lua x = vim.fn.stdpath("data")
:lua print(x)
OR
:lua x = vim.fn.stdpath("data"); print(x)

print a lua table
:lua print(vim.inspect(some_table))

# join lines without a space
gJ (instead of just J)

# do an action by a number value in a register
assume value 3 in @a
`@ap` to paste 3 times

# unnamed register (the default register)
@

# for all register types
:helpgrep types of registers

# jump to open or close of things
go to open {
[{
go to close }
[}
works for other open/closes aswell

# expression register (math)
@= or "=
in insert mode: <ctrl>+r =10+10
will place 20 where you were in insert mode
in visual mode:
  1. select math expression and delete it into your unnamed register
  2 <ctrl>+r = <ctrl>+r " <cr>
using other fns:
divide total count of lines in file divided by 3
=line('$') / 3

# apply macro (from the q reg) to whole file
:%norm @q

# global search
join paragraph chunks of numbers into 1 line separated by a space
:g/\d/-1j

# very magic mode (\v)
Remove need to escape paraens
> :'<,'>s,\v(un),e\U\1,g
make slash searches smarter
/\v
ignore case
/\c
dont ignore case
/\C

# expressions in substition
replace char with its number value -65 + 27
:%s/[A-Z]/\=char2nr(submatch(0))-65+27/g
:s/\v(\d+)/\=str2nr(submatch(0)) + 1/g
:s/\(\d\+\)/\=str2nr(submatch(0)) + 1/g

# WORKFLOW: copy (w/ unnamed) from vim buffer to vim command mode
copy something into unnamed register
enter cmd mode (either with visual selection or not) then press `<c-r>"`; this will paste the unnamed register into the command mode line

# negative match (invert a match) \@!
match lines that dont start with a digit
g/^\d\@!

# print non printable characters
print escape
in insert mode: <c-v><esc>

# run a scriptin (a file that is as if you typed it) against a file (-s scriptin flag)

vim ./file_to_run_against.txt -s script_to_run.vim

example in this repo:
cd ./vim/scriptin;
cp input.txt input-dirty.txt; vim ./input-dirty.txt -s ./input.scriptin; cat ./input-dirty.txt; rm ./input-dirty.txt;

# text objects
tag (t)
  good for html like structure
  dat (deletes around a tag)

# methods
go to next method
]m
go to prev method
[m

# vim args
set args list to all python files
:args **/*.py

view all args side by side
:vert sall

diff them
:windo diffthis

# include search (will search imports aswell)
:ij <search_phrase>
settings:
:echo &include
:echo &includeexpr
" what is attempted to add to the back of a import symbol when building potental path for an imported file (.py for python)
:echo &suffixadd
" show all included/linked files for current buffer
:checkpath!


# goes up and down long lines that are soft broken rather than going to next/prev line
gj
gk
g$
g0

# will break up long lines (or text objectt)
line
gqq
OR
Vgq
paragraph
gqp

# upper case whole line
gUU
OR
VgU

# switch caps of chars
~
for whole line switch caps
V~
OR
g~~

# reselect last visual selection
gv

# run your last substition on the whole doc
g&

# more on g
:help g

# select mode
enter it by:
gh


# E576: Error while reading ShaDa file: last entry specified that it occupies 117 bytes, but file ended earlier
fix by:
rm ~/.local/share/nvim/shada/*; rm  ~/.local/state/nvim/shada/*;

# commentstring
# set commentstring locally to -- . good for sql
setlocal commentstring=--\ %s

# Macros

to rerun a macro
@@
OR
<shift><register> --example: Q to use q register

to look at big big files (launch without plugins)
vim -u NONE <file>
