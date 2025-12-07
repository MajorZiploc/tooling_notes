# remove elements with 40 or more length (maps so it keeps everything)
jq '.scripts |= map(select(length >= 40))'


# return items that meet conditions with null guards
jq '.items
  | map(
      select(
        (.Variables | any(.Value? // "" | test("^acadian"; "i"))) and
        (.Variables | any(.Value? // "" | test("Employees"; "i")))
      )
    )'

# get back multiple fields from each ele in list in json format
jq '.[] | {firstname,lastname}'

# get back multiple fields from each ele in list in BASIC csv format with access of first ele of nested list
jq '.[] | .firstname + "," + .lastname + "," + (.registration_references[0].employee_number)'

# filter json to keys that contain "key_name_part"
jq 'with_entries(select(.key | test("key_name_part"; "i")))'
