# NOTE for zsh users: the ${!...} does not work in zsh
#
# regex graph generator
# https://regexper.com/

( ) # (for subshell) can be used to basically join stdout and the pipe will redirect all the output of all commands in the ( )
{ } # (for current shell)
(ls; ls) | less # content of directory listed twice in list
{ ls ; ls; } | less # content of directory listed twice in list -- SPACES AND SEMI COLONS ARE IMPORTANT IN THIS!

# glob eq to regex .*.(js|ts)
*.{.js,.ts}
# recursive glob **
**/*.json

# find the execution time in seconds of a command, just prefix your command with time
time <command can have spaces>

# ex: ls -a - ~
# -	End of options flag. All other arguments are positional parameters.

# --	Unset positional parameters. If arguments given (-- arg1 arg2), positional parameters set to arguments.

# less: or (tail -f | less +F )
# while in less. use shift+F to auto refresh the file. To toggle it off, use Ctrl+C

column -t: # makes the output look easy to read
mount
mount | column -t

# Parameter expansion:
# : means to count empty string as unset
# using param@/param* or param[@]/param[*] can change the param expansion behavior

cd ~- | cd - # goes back to the previous working directory

# puts that history entry as your last entry in history (useful when paired with fc flow)
!<number>:p

# executes that history entry
!<number>:p

# jobs - NOTE: they will end when you end your terminal session unlike tmux
# put a foreground task into the background
# <ctrl>-z
# lists open jobs
jobs
# brings the last open job to the foreground
fg
# brings id 1 task to the foreground
fg % 1

# interesting way to check for arguments
if [[ "$*" == *"--debug"* ]] || [[ "${DEBUG}" == "true" ]]; then
    set -x
fi

# Conditionals:
# assign param to default if its null
${param:=default}
# use default if param null
${param:-default}
# returns non zero and uses error expression if param is null
${param:?error}
# default error message roughly: f:param: param: parameter not set
${param:?}
# use alternate if param is nonnull
${param:+alternate}
# string checks
test -z $var && echo "string is null/empty" || echo "string is not null/empty"
test -n $var && echo "string is not null/empty" || echo "string is null/empty"
== => Check for string equality.
!= => Check for string inequality.
# file/dir checks
test -e $var && echo "var is a file or sym link" || echo "var is not a file or sym link"
test -f $var && echo "var is a file" || echo "var is not a file"
test -d $var && echo "var is a dir" || echo "var is not a dir"
test -s $var && echo "var is a not zero byte file" || echo "var is a zero byte file"

# ! negates condition
[[ ! -s ~/Desktop/zero_byte.txt ]]

# integer checks
-eq => Integer X is equal to Integer Y
-ne => Integer X is not equal to Integer Y
-gt => Integer X is greater than Integer Y
-ge => Integer X is greater than or equal to Integer Y
-lt => Integer X is lesser than Integer Y
-le => Integer X is lesser than or equal to Integer Y

# OR condition
[[ $X -eq 10 || $Y -eq 10 ]]

# Extraction:
# returns the rest of param after the offset
${param:offset}
# returns chars of length size after the offset for param
${param:offset:length}

# Removal from left edge:
${param#glob_pattern} # non greedy
${param##glob_pattern} # greedy
# Removal from right edge:
${param%glob_pattern} # non greedy
${param%%glob_pattern} # greedy

# Indirect Expansion: like pointers
${!param}
# List variables that match a glob pattern
${!pa@}
# List keys in an array (usually indices)
${!name[@]}
# get length of variable or array
${#param} || ${#param[@]}
# making array from command
# ok
local files; files=($(gfind_files "$file_pattern" | xargs));
# better
local files; local OGIFS=$IFS; IFS=$'\n' read -ra files <<< "$(gfind_files "$file_pattern")"; IFS=$OGIFS

# search for variables declared
set | egrep "<variable_pattern>"

# Substition:
${param/search_glob_pattern/replacement_text} # non greedy
${param//search_glob_pattern/replacement_text} # greedy
# Substition at left edge:
${param/#search_glob_pattern/replacement_text} # non greedy
# Substition at right edge:
${param/%search_glob_pattern/replacement_text} # non greedy

# use a capture group from a bash match [1] here for the first capture group
if [[ $file =~ packages/([^/]+) ]]; then
  do_thing ${BASH_REMATCH[1]}
fi

# Arrays:
# init array with elements
array=(zero one "two three")
# add an element to an array
array+=("four and beyound")
# replace space with underscore in array elements
array=("${array[@]// /_}")
# init array from number generator
array=(`echo {0..10}`)
# removes the first element
unset arr[0]
# removes the first element
array=("${array[@]:1}")
# recreate array with elements from index 2 to 4
array=("${array[@]:2:3}")
# remove the first 2 arguments
set -- "${@:3}"

# Generate number ranges
# start can include padding required for numbers
# {start..end..step}
echo {001..777..3}

# Associative Array
# init/create 1
declare -A assArray1
assArray1[fruit]=Mango
assArray1[bird]=Cockatail
assArray1[flower]=Rose
assArray1[animal]=Tigar
# init/create 2
declare -A assArray2=( [HDD]=Samsung [Monitor]=Dell [Keyboard]=A4Tech )
# Accessing elements
# get value for a key
echo ${assArray1[bird]}
echo ${assArray1[flower]}
# show keys 1
for key in "${!assArray1[@]}"; do echo $key; done
# show keys 2
echo "${!assArray1[@]}"
# show values 1
for val in "${assArray1[@]}"; do echo $val; done
# show values 2
echo "${assArray1[@]}"
# access key and value
for key in "${!assArray1[@]}"; do echo "$key => ${assArray1[$key]}"; done
# zsh varient:
for key value in ${(kv)assArray1}; do echo "$key -> $value"; done
# add new data to an associative array
assArray2+=([Mouse]=Logitech)
# remove entry
unset assArray2[Monitor]
# check for key
if [ ${assArray2[Monitor]+_} ]; then echo "Key exists"; else echo "Key does not exists"; fi
# delete associative array
unset assArray1

# Interactive search up history for command
# <CTRL>-R
# Run last command in history that starts with string
!string
# Puts last command in history that starts with string as last entry in history
!string:p

# Special parameters

# argument list
$@ or $* -- act different when in quotes. $* uses first IFS char for separation
# number of elements in argument list
$#
# shell interactive flags
$-
# shell that is currently being used
$0
# process id
$$
# process id of most recent job that occurred
$!

# glob notes:
  # For all nonhidden files/folders in current directory non-recursive, use -d '*'
  # For all hidden files/folders in current directory non-recursive, use -d '.[^.]*'
  # For all hidden and nonhidden files/folders in current directory non-recursive, use -d '* .[^.]*'

# copy contents of source to existing dir dest, including hidden stuff
# cp -a /source/. /dest/

# basic auth with curl
curl --anyauth -u "<user>:<pass>"

# interesting error handling pattern sh
function exit_early {
  printf "\n"
  exit 1
}
printf "${CYAN}\nPulling changes to ${PWD##*/}...\n\n${DEFAULT_COLOR}"
trap 'git_pull_err' ERR
function git_pull_err {
  exit_early
}
git pull
trap - ERR

# Extra snippets:
pwsh -ExecutionPolicy [Bypass | Unrestricted | RemoteSigned| AllSigned | Default | Undefined | Restricted] -File '/path/to/script.ps1 -Flag arg'
pwsh -ExecutionPolicy [Bypass | Unrestricted | RemoteSigned| AllSigned | Default | Undefined | Restricted] -Command "& {Write-Host 'hi'}"
perl -ne 'print unless $seen{$_}++' # unique without sorting

# FROM WINDOWS GIT BASH:
################################## Construct PATH variable ##################################

#winpath=$(echo $MSYS2_WINPATH | tr ";" "\n" | sed -e 's/\\/\\\\/g' | xargs -I {} cygpath -u {})
#unixpath=''

# Set delimiter to new line
#IFS=$'\n'

#for pth in $winpath; do unixpath+=$(echo $pth)":"; done

#export PATH=$(echo $PATH:$unixpath | sed -e 's/:$//g')
#unset IFS
#unset unixpath
#unset winpath

################################# Constructed PATH variable #################################

# UNIX COMMAND NOTES BEGIN

# Create a .tgz file
tar zcf </file/path.tgz> <content that can be an array or string>

# Read a .tgz file
tar ztf </file/path.tgz>

# UNIX COMMAND NOTES END

