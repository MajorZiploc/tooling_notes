
# remove elements with 40 or more length (maps so it keeps everything)
jq '.scripts |= map(select(length >= 40))'

# get back multiple fields from each ele in list in json format
jq '.[] | {firstname,lastname}'

# get back multiple fields from each ele in list in BASIC csv format with access of first ele of nested list
jq '.[] | .firstname + "," + .lastname + "," + (.registration_references[0].employee_number)'
