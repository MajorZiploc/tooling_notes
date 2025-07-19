function to_mac_helper {
  # NOTE: NOT PERFECT
  local file="$1";
  local program_patterns=("krita~/Applications/krita.app" "gimp~/Applications/gimp.app");
  for program_pattern in ${program_patterns[@]}; do
    local search_pattern="`echo "$program_pattern" | sed -E 's,(.*)~(.*),\1,'`";
    local replace_pattern="`echo "$program_pattern" | sed -E 's,(.*)~(.*),\2,'`";
    sed -E -i'' 's,(<path>).*('"$search_pattern"')\.exe(</path>),\1'"$replace_pattern"'\3,g' "$file";
  done;
  sed -E -i'' 's,<(K[[:digit:]]+)([^>]*)>([^>]*)Ctrl([^>]*)(</\1>),<\1\2>\3Command\4\5,g' "$file";
}
