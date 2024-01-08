function just_get_color_map {
  local color_replace_config;color_replace_config="$(cat ./color_replace_config.json)";
  local color_palette; color_palette="$(echo "$color_replace_config" | jq -r ".color_palette")";
  local from_color_ramp; from_color_ramp="$(echo "$color_replace_config" | jq -r ".from.color_ramp")";
  local to_color_ramp; to_color_ramp="$(echo "$color_replace_config" | jq -r ".to.color_ramp")";
  local query;
  query="
  Select
    a.r as from_r
    , a.g as from_g
    , a.b as from_b
    , b.r as to_r
    , b.g as to_g
    , b.b as to_b
  join ./colors.csv on a.color_palette = b.color_palette and a.color_ramp_priority = b.color_ramp_priority
  where
    a.color_palette == '${color_palette}'
    and a.color_ramp == '${from_color_ramp}'
    and b.color_ramp == '${to_color_ramp}'
  order by a.color_ramp_priority asc
  ";
  cat ./colors.csv | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null;
}
