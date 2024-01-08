function just_get_color_ramp_change_map {
  local config; config="$(cat ./color_ramp_change_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";

  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local from_color_ramp;
  local to_color_ramp;
  local query_result;
  for ((idx=0; idx<replacement_length; idx++)); do
    from_color_ramp="$(echo "$config" | jq -r ".replacements[$idx].from_color_ramp")";
    to_color_ramp="$(echo "$config" | jq -r ".replacements[$idx].to_color_ramp")";
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

function just_get_color_ramp_shift_map {
  local config;config="$(cat ./color_ramp_shift_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";
  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local color_ramp;
  local query_result;
  for ((idx=0; idx<replacement_length; idx++)); do
    color_ramp="$(echo "$config" | jq -r ".replacements[$idx].color_ramp")";
    shift_step="$(echo "$config" | jq -r ".replacements[$idx].shift_step")";
    start_idx="$(echo "$config" | jq -r ".replacements[$idx].start_idx")";
    end_idx="$(echo "$config" | jq -r ".replacements[$idx].end_idx")";
    query="
    Select
      '{' + f'from=Color({a.r}, {a.g}, {a.b})' + f', to=Color({b.r}, {b.g}, {b.b})' + '},' as color_mapping
      join ./colors.csv on a.color_palette = b.color_palette
    where
      a.color_palette == '${color_palette}'
      and a.color_ramp == '${color_ramp}'
      and a.color_ramp == b.color_ramp
      and int(a.color_ramp_priority) >= ${start_idx}
      and int(a.color_ramp_priority) <= ${end_idx}
      and int(a.color_ramp_priority) == (int(b.color_ramp_priority) + ${shift_step})
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
