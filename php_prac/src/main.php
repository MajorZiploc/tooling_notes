<?php

function math_examples() {
  $many = 2.2888800;
  $many_2 = 2.2111200;
  $few = $many + $many_2;
  print("$many + $many_2 = $few <br>");
}

function truthyness_examples() {
  # Truthyness
  $true_num = 3 + 0.14159;
  $true_str = "Tried and true";
  $true_array[49] = "An array element";
  $false_array = array();
  $false_null = NULL;
  $false_num = 999 - 999;
  $false_str = "";
}

function single_double_quote_examples() {
  # single vs double quote with variables
  $variable = "name";
  $literally = 'My $variable will not print!';
  print($literally);
  print "<br>";
  $literally = "My $variable will print!";
  print($literally);
  print("\n");
  print("\n");
}

function multiline_string_examples() {
  # Here documents
$channel =<<<_XML_
<channel>
  <title>What's For Dinner</title>
  <link>http://menu.example.com/ </link>
  <description>Choose what to eat tonight.</description>
</channel>
_XML_;

echo <<<END
This uses the "here document" syntax to output multiple lines with variable
interpolation. Note that the here document terminator must appear on a line with
just a semicolon. no extra whitespace!


END;

  print $channel;
}

function condtional_examples($d) {
  print("\n");
  # if/elseif/else
  if ($d == "Fri")
    echo "Have a nice weekend!";
  elseif ($d == "Sun")
    echo "Have a nice Sunday!";
  else
    echo "Have a nice day!";
}

print("\n");

function switch_examples($d) {
  switch ($d){
    case "Mon":
      echo "Today is Monday";
      break;
    default:
      echo "Not Monday";
  }
}

function main() {
  math_examples();
  truthyness_examples();
  single_double_quote_examples();
  multiline_string_examples();
  $d = date("D");
  # has standard operators and a ternary operator
  condtional_examples($d);
  switch_examples($d);
}

main();

?>
