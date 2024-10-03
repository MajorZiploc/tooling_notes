
# remove elements with 40 or more length (maps so it keeps everything)
jq '.scripts |= map(select(length >= 40))'
