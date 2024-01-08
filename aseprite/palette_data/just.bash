function just_get_color_map {
  local color_replace_config;color_replace_config="$(cat ./color_replace_config.json)";
  local color_palette; color_palette="$(echo "$color_replace_config" | jq -r ".color_palette")";

  local replacement_length; replacement_length="$(echo "$color_replace_config" | jq -r ".replacements | length")"
  local query;
  local from_color_ramp;
  local to_color_ramp;
  local query_result;
  for ((idx=0; idx<replacement_length; idx++)); do
    from_color_ramp="$(echo "$color_replace_config" | jq -r ".replacements[$idx].from_color_ramp")";
    to_color_ramp="$(echo "$color_replace_config" | jq -r ".replacements[$idx].to_color_ramp")";
    query="
    Select
      '{' + f'from=Color({a.r}, {a.g}, {a.b})' + f', to=Color({b.r}, {b.g}, {b.b})' + '},' as color_mapping
    join ./colors.csv on a.color_palette = b.color_palette and a.color_ramp_priority = b.color_ramp_priority
    where
      a.color_palette == '${color_palette}'
      and a.color_ramp == '${from_color_ramp}'
      and b.color_ramp == '${to_color_ramp}'
    order by a.color_ramp_priority asc
    ";
    query_result="$(cat ./colors.csv | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    if [[ "${idx}" == "0" ]]; then
      echo "$query_result";
    else
      echo "$query_result" | tail -n +2;
    fi
  done;
}
