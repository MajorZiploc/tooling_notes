<?php
// Loads deps/libs from composer
require_once 'vendor/autoload.php';

// Use Ds for proper datastructures in php

function math_examples() {
  echo "\n";
  echo "math_examples()";
  echo "\n";
  $many = 2.2888800;
  $many_2 = 2.2111200;
  $few = $many + $many_2;
  print("$many + $many_2 = $few <br>");
}

function truthyness_examples() {
  echo "\n";
  echo "truthyness_examples()";
  echo "\n";
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
  echo "\n";
  echo "single_double_quote_examples()";
  echo "\n";
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
  echo "\n";
  echo "multiline_string_examples()";
  echo "\n";
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

function conditional_examples($d) {
  echo "\n";
  echo "conditional_examples()";
  echo "\n";
  print("\n");
  # NOTE: Prefer === over ==
  # if/elseif/else
  if ($d === "Fri")
    echo "Have a nice weekend!";
  elseif ($d === "Sun")
    echo "Have a nice Sunday!";
  else
    echo "Have a nice day!";
  # spaceship operator
  echo 1 <=> 1; // Outputs 0
  echo 1 <=> 2; // Outputs -1
  echo 2 <=> 1; // Outputs 1
  echo "a" <=> "a"; // Outputs 0
  echo "a" <=> "b"; // Outputs -1
  echo "b" <=> "a"; // Outputs 1
}

print("\n");

function switch_examples($d) {
  echo "\n";
  echo "switch_examples()";
  echo "\n";
  switch ($d){
    case "Mon":
      echo "Today is Monday";
      break;
    default:
      echo "Not Monday";
  }
  echo "\n";
}

function basics() {
  echo "\n";
  echo "basics()";
  echo "\n";
  math_examples();
  truthyness_examples();
  single_double_quote_examples();
  multiline_string_examples();
  $d = date("D");
  # has standard operators and a ternary operator
  conditional_examples($d);
  switch_examples($d);
  // null check
  $x = null;
  $y = 1;
  $is_x_null = is_null($x);
  $not_is_x_null = isset($x);
  echo "x: $x; y: $y";
  echo "\n";
  echo "is_x_null: $is_x_null";
  echo "\n";
  echo "not_is_x_null: $not_is_x_null";
  echo "\n";
  $is_y_null = is_null($y);
  $not_is_y_null = isset($y);
  echo "is_y_null: $is_y_null";
  echo "\n";
  echo "not_is_y_null: $not_is_y_null";
  echo "\n";
  $z = "" ? "empty string is true" : "empty string is false";
  echo "$z";
  echo "\n";
  // || and && give back true and false, not values like python or js
  $z = "" || "yeet";
  echo "$z";
  echo "\n";
  $z = "" && "yeet";
  echo "$z";
  echo "\n";
  // null coalaese: doesnt follow the truthy/falsey table exactly
  //  false and null are false, else its usually a truth value
  $z = 1 ?? "yeet";
  echo "$z";
  echo "\n";
}

function date_prac() {
  echo "\n";
  echo "date_prac()";
  echo "\n";
  // Returns the full date and time
  echo date("r");
  echo "\n";
}

function dictionary_prac() {
  echo "\n";
  echo "dictionary_prac()";
  echo "\n";
  // no true dictionary in php. use pair like arrays (associative array)
  $dictionary = array(
    "foo" => "bar",
    "bar" => "foo",
  );
  // php 5.4+
  $dictionary = [
    "foo" => "bar",
    "bar" => "foo",
  ];
  // print dictionary like a .join(" ")
  echo implode(" ", $dictionary);
  echo "\n";
  // access value by key
  echo $dictionary["foo"];
  echo "\n";
  // loop through key value pairs
  foreach ($dictionary as $key => $value)
    echo "$key $value";
    echo "\n";
  // explicty unset the key value from the last entry in the dict else bad things will happen
  // will work even if the dictionary had no elements
  // unset takes a list of variables to unset
  unset($key, $value);
  // remove entry from dictionary
  unset($dictionary["foo"]);
  // print_r easy print; human readable printing of variables
  print_r($dictionary);
  echo "\n";
  // ignore warning if key does not exist in dictionary
  $value = @$dictionary["bad_key"];
  echo "no value: $value";
  echo "\n";
  // concat dictionarys '+' - will keep the first seen key value pair if conflicts occur (items in arr1 in this case)
  $arr1 = array('one' => 'foo', 'two' => 'baz');
  $arr2 = array('two' => 'bar');
  // Will contain array('one' => 'foo', 'two' => 'baz');
  $combined = $arr1 + $arr2;
  echo implode(" ", $combined);
  // concat dictionarys 'array_merge' - will keep the most recently seen key value pair if conflicts occur (items in arr2 in this case)
  // Will contain array('one' => 'foo', 'two' => 'bar');
  $combined = array_merge($arr1, $arr2);
  echo implode(" ", $combined);
  echo "\n";
}

function array_prac() {
  echo "\n";
  echo "array_prac()";
  echo "\n";
  // nested array unpack
  $array = [
    [1, 2],
    [3, 4],
  ];
  foreach ($array as list($a, $b)) {
      // $a contains the first element of the nested array,
      // and $b contains the second element.
      echo "A: $a; B: $b\n";
  }
  // unset takes a list of variables to unset
  unset($a, $b);
  // unpacking
  list($a, $b) = $array[0];
  echo "A: $a; B: $b\n";
  echo "\n";
  // membership check
  $fruits = array("apple", "banana", "orange");
  if (in_array("apple", $fruits)) {
    echo "Found apple in the array\n"; // Output: Found apple in the array
  }
  if (in_array("grape", $fruits)) {
    echo "Found grape in the array\n";
  } else {
    echo "Did not find grape in the array\n"; // Output: Did not find grape in the array
  }
  // .map()
  $numbers = [1, 2, 3, 4, 5];
  $squared_numbers = array_map(function($number) {
    return $number * $number;
  }, $numbers);
  // short hand arrow function
  // NOTE: array_map does not mutate the input array
  $squared_numbers = array_map(fn($number) => $number * $number, $numbers);
  print_r($squared_numbers);
  // .filter()
  $numbers = [1, 2, 3, 4, 5];
  $even_numbers = array_filter($numbers, function($number) {
    return $number % 2 == 0;
  });
  print_r($even_numbers); // Output: Array ( [1] => 2 [3] => 4 )
  // .reduce()
  $numbers = [1, 2, 3, 4, 5];
  $total = array_reduce($numbers, function($accumulator, $number) {
    return $accumulator + $number;
  }, 0);
  echo $total; // Output: 15
  echo "\n";

  $arr1 = array('foo'); // Same as array(0 => 'foo')
  $arr2 = array('bar'); // Same as array(0 => 'bar')
  // concat arrays array_merge
  $combined = array_merge($arr1, $arr2);
  echo implode(" ", $combined);
  echo "\n";
  // concat arrays '+' - will work more like a dict where keys are the indices of the array
  //  it will only keep the first key it sees. so if it sees an index 0, it keeps the first one
  //  a good way to right pad an array
  $combined = $arr1 + $arr2;
  echo implode(" ", $combined);
  echo "\n";
}

interface MyInterface {
  public function myMethod();
}
interface MyInterface2 {
  public function myMethod2();
}
abstract class AClass implements MyInterface, MyInterface2 {
  public $property;
  abstract public function myMethod();
  public function myMethod2() {
    echo "method 2";
    echo "\n";
  }
}
class MyClass extends AClass implements MyInterface, MyInterface2 {
  public function myMethod() {
    echo "method 1";
    echo "\n";
  }
}

// classes are very cpp like
function class_prac() {
  echo "\n";
  echo "class_prac()";
  echo "\n";
  $myObject = new MyClass();
  $myObject->property = 'some value';
  $myObject->myMethod();
  $myObject->myMethod2();
}

class MyEnum {
    const VALUE1 = 'value1';
    const VALUE2 = 'value2';
    const VALUE3 = 'value3';

    public static function isValid($value) {
        $reflectionClass = new ReflectionClass(get_called_class());
        return in_array($value, $reflectionClass->getConstants());
    }
}
// no true enum in php
function enum_prac() {
  echo "\n";
  echo "enum_prac()";
  echo "\n";
  $value = 'value2';
  if (MyEnum::isValid($value)) {
    echo "Is valid enum value";
    echo "\n";
  }
}

function ds_prac() {
  echo "\n";
  echo "ds_prac()";
  echo "\n";
  $set = new Ds\Set();
  $set->add('foo');
  $set->add('bar');
  $set->add('baz');
  // membership check
  if ($set->contains('foo')) {
      echo "Value 'foo' is in the set.\n";
  }
  $set->remove('bar');
  foreach ($set as $value) {
      echo $value . "\n";
  }
}


function named_arg_pass_example($param1, $param2, $param3) {
  echo "\n";
  echo "named_arg_pass_example()";
  echo "\n";
  print_r("param1: $param1");
  print_r("\nparam2: $param2");
  print_r("\nparam3: $param3");
  echo "\n";
}

function string_prac() {
  echo "\n";
  echo "string_prac()";
  echo "\n";
  // translate chars - basic tr
  $r = strtr("abc123", "a1", "A9");
  print_r($r);
  echo "\n";
  $r = trim("   yo we   trimmin   ");
  print_r($r);
  echo "\n";
  // regex replace
  $string = 'April 15, 2003';
  $pattern = '/(\w+) (\d+), (\d+)/i';
  $replacement = '${1}1,$3';
  echo "regex replace\n";
  echo preg_replace($pattern, $replacement, $string);
  echo "\n";
  $pattern = '/(\d+)/i';
  // filter a list of strings by regex
  echo "regex filter array of strings\n";
  echo implode(" ", preg_grep($pattern, ["2", "5", "t"]));
  echo "\n";
  echo "check if string matches regex";
  echo preg_match($pattern, "2");
  echo "\n";
  echo "concat strings";
  echo "\n";
  echo "y" . "z boy";
  echo "\n";
  $haystack = "saucey boy";
  $needle = "sauce";
  // .startsWith()
  $does_start_with_sauce = str_starts_with($haystack, $needle);
  echo "does_start_with_sauce: $does_start_with_sauce for '$haystack' looking for '$needle'";
  echo "\n";
  // .endsWith()
  $does_end_with_sauce = str_ends_with($haystack, $needle) ? 'YE' : 'NOPE!';
  echo "does_end_with_sauce: $does_end_with_sauce for '$haystack' looking for '$needle'";
  echo "\n";
  // .includes()
  $does_contain_sauce = str_contains($haystack, $needle);
  echo "does_contain_sauce: $does_contain_sauce for '$haystack' looking for '$needle'";
  echo "\n";
}

function main() {
  basics();
  dictionary_prac();
  array_prac();
  class_prac();
  enum_prac();
  ds_prac();
  // Call the function using an associative array for named parameters
  $named_arg_pass_example_args = [
          'param2' => 'value2',
          'param3' => 'value3',
          'param1' => 'value1',
  ];
  // splat or variadic operator `...` (known as spread in js) is available in php8+
  /* named_arg_pass_example(...$named_arg_pass_example_args); */
  // call_user_func_array instead of `...` before php8
  call_user_func_array('named_arg_pass_example', $named_arg_pass_example_args);
  string_prac();
  date_prac();
}

main();

?>
