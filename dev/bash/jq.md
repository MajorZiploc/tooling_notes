
# remove elements with 40 or more length (maps so it keeps everything)
jq '.scripts |= map(select(length >= 40))'

# get back multiple fields from each ele in list in json format
jq '.[] | {firstname,lastname}'
