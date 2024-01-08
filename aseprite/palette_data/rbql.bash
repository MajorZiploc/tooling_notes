# TODO: make rest of bash script put this in a for loop to loop over the from and to color_ramp and priority and then generate a lua list to use in ReplaceColor lua aseprite script
# TODO: proly should convert to python and import the rbql pip package to do this stuff

cat ./colors.csv | rbql --with-header --query "
Select
  a.r as from_r
  , a.g as from_g
  , a.b as from_b
  , b.r as to_r
  , b.g as to_g
  , b.b as to_b
  , a.color_ramp_priority
join ./colors.csv on a.color_palette = b.color_palette and a.color_ramp_priority = b.color_ramp_priority
where
  a.color_palette == 'apollo'
  and a.color_ramp_priority == '5'
  and a.color_ramp == 'blue'
  and b.color_ramp == 'purple'
" --delim ',' --policy quoted_rfc
