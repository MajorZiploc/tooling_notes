# grabbing a database query and converting it to a json
_json="$(convert_csv_to_json "<csv_file_here>")";

# extra processing on the json if needed
node -e "
const json = $_json;
console.log(Object.fromEntries(json.map(ts => [ts.key, ts.value])));
";

