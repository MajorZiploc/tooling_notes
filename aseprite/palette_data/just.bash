function just_get_color_ramp_change {
  local config; config="$(cat ./color_ramp_change_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";
  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local from_color_ramp;
  local to_color_ramp;
  local query_result;
  local header;
  for ((idx=0; idx<replacement_length; idx++)); do
    from_color_ramp="$(echo "$config" | jq -r ".replacements[$idx].from_color_ramp")";
    to_color_ramp="$(echo "$config" | jq -r ".replacements[$idx].to_color_ramp")";
    query="
    Select
      '{' + f'from=Color({a.r}, {a.g}, {a.b})' + f', to=Color({b.r}, {b.g}, {b.b})' + '},' as color_mapping
    join ./colors.csv on a.color_palette = b.color_palette and a.color_ramp_idx = b.color_ramp_idx
    where
      a.color_palette == '${color_palette}'
      and a.color_ramp == '${from_color_ramp}'
      and b.color_ramp == '${to_color_ramp}'
    order by a.color_ramp_idx asc
    ";
    query_result="$(cat ./colors.csv | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    header="$(echo "$query_result" | head -n 1)";
    query_result="$(echo "$query_result" | tail -n +2;)";
    if [[ "${idx}" == "0" ]]; then
      echo "$header";
    fi
    echo "$query_result";
  done;
}

function just_get_color_ramp_shift {
  local config;config="$(cat ./color_ramp_shift_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";
  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local color_ramp;
  local shift_step;
  local start_idx;
  local end_idx;
  local query_result;
  local header;
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
      and int(a.color_ramp_idx) >= ${start_idx}
      and int(a.color_ramp_idx) <= ${end_idx}
      and int(a.color_ramp_idx) == (int(b.color_ramp_idx) + ${shift_step})
    order by a.color_ramp_idx asc
    ";
    query_result="$(cat ./colors.csv | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    header="$(echo "$query_result" | head -n 1)";
    query_result="$(echo "$query_result" | tail -n +2;)";
    if [[ "${idx}" == "0" ]]; then
      echo "$header";
    fi
    if [[ ${shift_step} -lt 0 ]]; then
      echo "$query_result" | tac;
    else
      echo "$query_result";
    fi
  done;
}

function just_get_color_idx_change {
  local config;config="$(cat ./color_idx_change_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";
  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local from_idx;
  local to_idx;
  local query_result;
  local header;
  for ((idx=0; idx<replacement_length; idx++)); do
    from_idx="$(echo "$config" | jq -r ".replacements[$idx].from_idx")";
    to_idx="$(echo "$config" | jq -r ".replacements[$idx].to_idx")";
    query="
    Select
      '{' + f'from=Color({a.r}, {a.g}, {a.b})' + f', to=Color({b.r}, {b.g}, {b.b})' + '},' as color_mapping
      join ./colors.csv on a.color_palette = b.color_palette
    where
      a.color_palette == '${color_palette}'
      and int(a.idx) == ${from_idx}
      and int(b.idx) == ${to_idx}
    order by a.idx asc
    ";
    query_result="$(cat ./colors.csv | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    header="$(echo "$query_result" | head -n 1)";
    query_result="$(echo "$query_result" | tail -n +2;)";
    if [[ "${idx}" == "0" ]]; then
      echo "$header";
    fi
    echo "$query_result";
  done;
}

function just_get_color_ramp_flip {
  local config;config="$(cat ./color_ramp_flip_config.json)";
  local color_palette; color_palette="$(echo "$config" | jq -r ".color_palette")";
  local replacement_length; replacement_length="$(echo "$config" | jq -r ".replacements | length")"
  local query;
  local asc_query;
  local desc_query;
  local color_ramp;
  local start_idx;
  local end_idx;
  local query_result;
  local agged_csv;
  local num_of_rows;
  local half_of_rows;
  local mid_step_alpha_value;
  local to_mid_step;
  local from_mid_step;
  local rest;
  for ((idx=0; idx<replacement_length; idx++)); do
    color_ramp="$(echo "$config" | jq -r ".replacements[$idx].color_ramp")";
    start_idx="$(echo "$config" | jq -r ".replacements[$idx].start_idx")";
    end_idx="$(echo "$config" | jq -r ".replacements[$idx].end_idx")";
    asc_query="
    Select
      a.r as ar
      , a.g as ag
      , a.b as ab
    where
      a.color_palette == '${color_palette}'
      and a.color_ramp == '${color_ramp}'
      and int(a.color_ramp_idx) >= ${start_idx}
      and int(a.color_ramp_idx) <= ${end_idx}
    order by a.color_ramp_idx asc
    "
    asc_query_result="$(cat ./colors.csv | rbql --with-header --query "$asc_query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    desc_query="
    Select
      a.r as br
      , a.g as bg
      , a.b as bb
    where
      a.color_palette == '${color_palette}'
      and a.color_ramp == '${color_ramp}'
      and int(a.color_ramp_idx) >= ${start_idx}
      and int(a.color_ramp_idx) <= ${end_idx}
    order by a.color_ramp_idx desc
    "
    desc_query_result="$(cat ./colors.csv | rbql --with-header --query "$desc_query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    agged_csv="$(paste -d "," <(echo "$asc_query_result") <(echo "$desc_query_result"))";
    query="
    Select
      '{' + f'from=Color({a.ar}, {a.ag}, {a.ab})' + f', to=Color({a.br}, {a.bg}, {a.bb})' + '},' as color_mapping
    ";
    query_result="$(echo "$agged_csv" | rbql --with-header --query "$query" --delim ',' --policy quoted_rfc 2> /dev/null | sed -E 's,(^"|"$),,g')";
    num_of_rows=$(echo -n "$query_result" | wc -l);
    half_of_rows=$(( (num_of_rows / 2) + (num_of_rows & 1) + 1 ));
    mid_step_alpha_value="72";
    to_mid_step="$(echo "$query_result" | head -n "$half_of_rows" | sed -E "s/(.*)\\)(.*?)/\\1, ${mid_step_alpha_value})\\2/g")";
    rest="$(echo "$query_result" | tail -n +"$(( half_of_rows + 1 ))")";
    from_mid_step="$(echo "$query_result" | head -n "$half_of_rows" | sed -E "s/.*to=(Color.*?)\\).*/{from=\\1, ${mid_step_alpha_value}), to=\\1)},/")";
    header="$(echo "$to_mid_step" | head -n 1)";
    to_mid_step="$(echo "$to_mid_step" | tail -n +2;)";
    if [[ "${idx}" == "0" ]]; then
      echo "$header";
    fi
    echo "$to_mid_step";
    echo "$rest";
    echo "$from_mid_step" | tail -n +2;
  done;
}
