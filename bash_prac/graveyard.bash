# alias graveyard:
alias git_deploy='git checkout develop && git pull && git push && { git checkout master 2>/dev/null || git checkout main 2>/dev/null ; } && git pull && git merge develop --commit --no-edit && git push && git checkout develop'

alias dir='ls --format=vertical'
alias vdir='ls --format=long'
  # under color guard
  alias dir='ls --color=auto --format=vertical'
  alias vdir='ls --color=auto --format=long'

# Default to human readable figures
alias df_h='df -h'
alias du_h='du -h'
alias curl_follow_redirects='curl -Lks'
alias curl_follow_redirects_ignore_security_exceptions='curl -0Lks'

alias kill_port='npx kill-port'

alias rg_nh='rg --no-heading'

alias vimi='vim -u NONE'
alias vimc='vim -u ~/vimfiles/rc-settings/common.vim'
alias vimt='vim -u ~/vimfiles/rc-settings/terminal.vim'
alias vimnp='vim --noplugin'


alias show_fn_names='declare -F'
alias show_fn_impls='declare -f'

alias back='cd ~-'

# requires <npm i gnomon -g> for the current user
alias time_js='gnomon'

alias space_to_newlines='tr " " "\n"'
alias colon_to_newline='tr ":" "\n"'

# function graveyard:

function hf {
  # show most commonly used commands based on frequency
  # $1: optional pos num to show last n entries
  local n="$1";
  [[ -z "$n" ]] && { n=25; }
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -n | tail -n "$n";
}

function ide1() {
  # splits the window into 2 panes
  tmux split-window -v -p 30;
}

function ide2() {
  # splits the window into 3 panes
  tmux split-window -v -p 30;
  tmux split-window -h -p 55;
}

function ide3() {
  # splits the window into 4 panes
  tmux split-window -v -p 30;
  tmux split-window -h -p 66;
  tmux split-window -h -p 50;
}

function show_find_full_paths() {
  # displays the full path names of $1 (the directory)
  # $1: optional directory. Defaults to .
  local dir="$1";
  dir=${dir:="."};
  find "$dir" -exec readlink -f "{}" \;
}

function set_power_set_experimental {
  # EXPERIMENTAL!
  # returns a set that contains all subsets of the set
  local set=$1;
  perl -le '
  sub powset {
   return [[]] unless @_;
   my $head = shift;
   my $list = &powset;
   [@$list, map { [$head, @$_] } @$list]
  }
  chomp(my @e = <>);
  for $p (@{powset(@e)}) {
   print @$p;
  }' $set
}

function set_cardesian_product_experimental {
  # EXPERIMENTAL!
  # returns a set that contains all possible pairs of elements from one set and the other
  # $1 x $2
  local set1=$1;
  local set2=$2;
  while read a; do while read b; do echo "$a, $b"; done < $set1; done < $set2;
}


function _extra_env_checks {
EXTRA_ENV_CHECKS_PLACEHOLDER
}

function show_env_notes {
  export ENV_NOTES="";
  # Dependency checks
  which npm >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing npm (node package manager)"; }
  which tmux >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing tmux (terminal multiplexier)"; }
  which pwsh >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing pwsh (cross platform powershell)"; }
  which gnomon >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing gnomon (npm package) for calculating time taking for commands"; }
  which prettier >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing prettier (npm package) for formatting various file formats"; }
  which concurrently >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing concurrently (npm package) for running multiple commands that hang a terminal without multiple terminals"; }
  which trash >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing trash-cli (npm package) safer rm"; }
  which rg >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing rg (ripgrep) a file content search utility"; }
  [[ -z $(dotnet --version 2>/dev/null | grep -E "^6") ]] && { ENV_NOTES="$ENV_NOTES:Missing dotnet v6 (cross platform dotnet cli tooling)"; }
  which just >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing just (a command runner for Justfiles)"; }
  which asdf >/dev/null 2>&1; [[ "$?" != "0" ]] && { ENV_NOTES="$ENV_NOTES:Missing asdf (a general programming language version manager)"; }
  _extra_env_checks;
  # final check on environment
  [[ -z "$ENV_NOTES" ]] && { ENV_NOTES="No missing dependencies! Setup is complete!"; }
  echo $ENV_NOTES | tr ":" "\n" | grep -Ev "^\\s*$"
}

extra_env_checks_placeholder="which fzf 2>\&1 2>/dev/null >/dev/null; [[ \"\$?\" != \"0\" ]] \&\& { ENV_NOTES=\"\$ENV_NOTES:Missing fzf (fuzzy finder)\"; }\nwhich python3 2>\&1 2>/dev/null >/dev/null; [[ \"\$?\" != \"0\" ]] \&\& { ENV_NOTES=\"\$ENV_NOTES:Missing python v3 \"; }\n";
find -E "$temp_shared" -iregex ".*bash.*" -type f -exec gsed -E -i'' "s,EXTRA_ENV_CHECKS_PLACEHOLDER,$extra_env_checks_placeholder,g" "{}" \;

function ideh1 {
  # splits the window into 2 panes
  tmux split-window -h -p 39;
}

function idev1 {
  # splits the window into 2 panes
  tmux split-window -v -p 30;
}

export GIT_DONT_ADD="just.bash *compose*.yml *compose*.yaml .env* .vim/* .devcontainer/* .vscode/*";

function git_add_all_kinda {
  git add .;
  dont_adds=($(echo "$GIT_DONT_ADD" | xargs));
  for dont_add in ${dont_adds[@]}; do
    git restore --staged "$dont_add";
  done;
}

function _parse_fields_helper {
  local fields="$1";
  local field_separator="$2";
  function _parse_fields_helper_inner {
    echo "$fields" | tr ":," "\n" | while read -d $'\n' field; do echo "\$(\$_.${field})${field_separator}"; done;
  }
  _parse_fields_helper_inner | perl -0777 -ple "s/(${field_separator})\$//" | tr -d "\n";
}

function _parse_fields_header_helper {
  local fields="$1";
  local field_separator="$2";
  echo "$fields" | sed -E "s/[:,]/${field_separator}/g";
}

function parse_json_fields {
  local json="$1";
  local fields="$2";
  local field_separator="$3";
  local preprocessing_pwsh="$4";
  field_separator="${field_separator:=","}";
  preprocessing_pwsh="${preprocessing_pwsh:=""}";
  [[ -z "$json" ]] && { echo "Must specify a json file or string\!" >&2; return 1; }
  [[ -z "$fields" ]] && { echo "Must specify fields! (list of fields delimited by commas or colons)" >&2; return 1; }
  _parse_fields_header_helper "$fields" "$field_separator";
  local pwsh_fields; pwsh_fields=$(_parse_fields_helper "$fields" "$field_separator" | tr -d "\n");
  if [[ -e "$json" ]]; then
    pwsh -command "&{ \$js=Get-Content '$json' | ConvertFrom-Json; \$js $preprocessing_pwsh | % { Write-Host \"$pwsh_fields\"; }; }";
  else
    json=$(echo "$json" | tr -d "\n");
    pwsh -command "&{ \$js=ConvertFrom-Json -InputObject '$json'; \$js $preprocessing_pwsh | % { Write-Host \"$pwsh_fields\"; }; }";
  fi
}

function parse_csv_fields {
  local csv="$1";
  local fields="$2";
  local field_separator="$3";
  local preprocessing_pwsh="$4";
  field_separator="${field_separator:=","}";
  preprocessing_pwsh="${preprocessing_pwsh:=""}";
  [[ -z "$csv" ]] && { echo "Must specify a csv file or string\!" >&2; return 1; }
  [[ -z "$fields" ]] && { echo "Must specify fields! (list of fields delimited by commas or colons)" >&2; return 1; }
  _parse_fields_header_helper "$fields" "$field_separator";
  local pwsh_fields; pwsh_fields=$(_parse_fields_helper "$fields" "$field_separator");
  if [[ -e "$csv" ]]; then
    pwsh -command "&{ \$cs=Get-Content $csv | ConvertFrom-Csv; \$cs $preprocessing_pwsh | % { Write-Host \"$pwsh_fields\"; }; }";
  else
    rows=$(echo "$csv" | tr -d '"' | sed -E 's/(.*)/"\1",/g');
    rows=$(echo "$rows" | perl -0777 -ple "s/,\$//");
    rows=$(echo "(" "$rows" ")");
    pwsh -command "&{ \$cs=$rows | ConvertFrom-Csv; \$cs $preprocessing_pwsh | % { Write-Host \"$pwsh_fields\"; }; }";
  fi
}

function vim_session {
  local default_session_name="./Session.vim";
  local session_name="${1:-"$default_session_name"}";
  [[ -e "$session_name" ]] || { echo "Must specify a session_name that is a valid file or sym link\!" >&2; return 1; }
  [[ "$session_name" == "$default_session_name" ]] || { cp "$session_name" "$default_session_name"; }
  local session_history_path="$HOME/vimfiles/sessions";
  local session_history_file="$session_history_path/history.csv";
  mkdir -p "$session_history_path";
  [[ -e "$session_history_file" ]] || { echo "project_path,session_name,fn_call_timestamp" > "$session_history_file"; }
  echo "`pwd`,$session_name,`date`" >> "$session_history_file";
  nvim -S "$default_session_name";
}

