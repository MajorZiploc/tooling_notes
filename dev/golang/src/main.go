package main

import (
  "fmt"
  "strings"
  "math/rand"
  "time"
  "strconv"
)

func comparsion_prac() {
  fmt.Println("----------------")
  fmt.Println("comparsion_prac")
  // you can compare two strings using the comparison operators ==, !=, <, <=, >, and >=
  // these work for numbers aswell
  // case insensitive comparsion
  s1 := "hello"
  s2 := "HELLO"
  if strings.EqualFold(s1, s2) {
    fmt.Println("The two strings are equal")
  } else {
    fmt.Println("The two strings are not equal")
  }
}

func number_prac() {
  fmt.Println("----------------")
  fmt.Println("number_prac")
  // Declare and initialize integer variables
  var num1 int = 10
  var num2 int = 20
  // Declare and initialize floating-point variables
  var float1 float32 = 3.14
  var float2 float64 = 6.28
  // Addition
  sum := num1 + num2
  fmt.Println(sum) // Output: 30
  // Subtraction
  diff := num2 - num1
  fmt.Println(diff) // Output: 10
  // Multiplication
  product := num1 * num2
  fmt.Println(product) // Output: 200
  // Division
  quotient := float2 / float64(float1)
  fmt.Println(quotient) // Output: 2.0
  // Incrementing a variable
  num1++
  fmt.Println(num1) // Output: 11
  // Decrementing a variable
  num2--
  fmt.Println(num2) // Output: 19
  // Converting an integer to a floating-point number
  result := float32(num1) / float1
  fmt.Println(result) // Output: 3.1746032
  // Converting a floating-point number to an integer
  intValue := int(float2)
  // convert an int to string
  fmt.Println(strconv.Itoa(num1))
  // convert a float64 to string
  fmt.Println(strconv.FormatFloat(float2, 'f', 3, 64))
  fmt.Println(intValue) // Output: 6
  // Generate a random integer between 1 and 10
  rand.Seed(time.Now().UnixNano())
  randomInt := rand.Intn(10) + 1
  fmt.Println(randomInt) // Output: a random integer between 1 and 10
}

func string_prac() {
  fmt.Println("----------------")
  fmt.Println("string_prac")
  // Concatenate two strings
  str1 := "hello"
  str2 := "world"
  result := str1 + " " + str2
  fmt.Println(result) // Output: hello world
  // Get the length of a string
  str := "apple"
  length := len(str)
  fmt.Println(length) // Output: 5
  // Convert a string to uppercase
  str = "hello"
  upper := strings.ToUpper(str)
  fmt.Println(upper) // Output: HELLO
  // Convert a string to lowercase
  str = "WORLD"
  lower := strings.ToLower(str)
  fmt.Println(lower) // Output: world
  // Split a string into a slice
  str = "apple,banana,orange"
  split := strings.Split(str, ",")
  fmt.Println(split) // Output: [apple banana orange]
  // Replace a substring in a string
  str = "hello world"
  newStr := strings.Replace(str, "world", "Go", -1)
  fmt.Println(newStr) // Output: hello Go
}

// array
func list_prac() {
  fmt.Println("----------------")
  fmt.Println("list_prac")
  // Create a slice of strings
  fruits := []string{"apple", "banana", "orange"}
  // Create an empty slice of integers
  numbers := []int{}
  fmt.Println(numbers)
  // Access an element of the slice
  fmt.Println(fruits[0]) // Output: apple
  // Slice a portion of the slice
  slice := fruits[1:3]
  fmt.Println(slice) // Output: [banana orange]
  // Append an element to the slice
  fruits = append(fruits, "pear")
  fmt.Println(fruits) // Output: [apple banana orange pear]
  // Iterate over the elements in the slice
  for i, fruit := range fruits {
    fmt.Printf("%d: %s\n", i, fruit)
  }
  // Get the number of elements in the slice
  length := len(fruits)
  fmt.Println(length)
}


func dictionary_prac() {
  fmt.Println("----------------")
  fmt.Println("dictionary_prac")
  // Create a dictionary with string keys and integer values
  dict := make(map[string]int)
  // Add some entries to the dictionary
  dict["apple"] = 1
  dict["banana"] = 2
  dict["orange"] = 3
  // Access an entry in the dictionary
  val := dict["apple"]
  fmt.Println(val) // Output: 1
  // Check if an entry exists in the dictionary
  if v, ok := dict["apple"]; ok {
    fmt.Sprintln("apple exists in the dictionary with value %i", v)
  }
  // Iterate over the keys and values in the dictionary
  for key, value := range dict {
    fmt.Printf("%s -> %d\n", key, value)
  }
  // Delete an entry from the dictionary
  delete(dict, "banana")
  // Get the number of entries in the dictionary
  length := len(dict)
  fmt.Println(length)
}

// Classes: not actually supported but this is the equal to them
// Define the Breatheable interface
type Breatheable interface {
  Breathe()
  Details(int) string
}
// Define the LivingThing abstract type
type LivingThing struct{}
// Implement the Breatheable interface for LivingThing
func (lt LivingThing) Breathe() {
  fmt.Println("I am breathing")
}
// Define the Person type
type Person struct {
  LivingThing
  Name string
  Age int
}
func (p Person) Details(n int) string {
  return "Input: " + strconv.Itoa(n)
}
// .toString()
func (p Person) String() string {
  return fmt.Sprintf("Person{Name: %s, Age: %d}", p.Name, p.Age)
}

// .map(), .filter(), .reduce()
type Mapper func(interface{}) interface{}
type Filterer func(interface{}) bool
type Reducer func(interface{}, interface{}) interface{}
// Map applies a function to each element in a slice and returns a new slice with the results.
func Map(items []interface{}, mapper Mapper) []interface{} {
  result := make([]interface{}, len(items))
  for i, item := range items {
    result[i] = mapper(item)
  }
  return result
}
// Filter returns a new slice containing only the elements that satisfy the predicate.
func Filter(items []interface{}, filterer Filterer) []interface{} {
  result := make([]interface{}, 0, len(items))
  for _, item := range items {
    if filterer(item) {
      result = append(result, item)
    }
  }
  return result
}
// Reduce applies a function to each element in a slice and returns the result.
func Reduce(items []interface{}, reducer Reducer, initialValue interface{}) interface{} {
  result := initialValue
  for _, item := range items {
    result = reducer(result, item)
  }
  return result
}

func map_filter_reduce_prac() {
  fmt.Println("----------------")
  fmt.Println("map_filter_reduce_prac")
  numbers := []interface{}{1, 2, 3, 4, 5}
  // Map example: square each number
  squares := Map(numbers, func(item interface{}) interface{} {
    number := item.(int)
    return number * number
  })
  fmt.Println(squares) // Output: [1 4 9 16 25]
  // Filter example: keep only even numbers
  evens := Filter(numbers, func(item interface{}) bool {
    number := item.(int)
    return number%2 == 0
  })
  fmt.Println(evens) // Output: [2 4]
  // Reduce example: sum of all numbers
  sum := Reduce(numbers, func(result interface{}, item interface{}) interface{} {
    number := item.(int)
    return result.(int) + number
  }, 0)
  fmt.Println(sum) // Output: 15
}

func class_prac() {
  fmt.Println("----------------")
  fmt.Println("class_prac")
  // Create a new Person
  p := Person{Name: "Bob", Age: 21}
  // Call the Breathe method on the Person, which is inherited from LivingThing
  p.Breathe()
  fmt.Println(p.Details(1))
  fmt.Println(p)
}

func generate() <-chan int {
  out := make(chan int)
  go func() {
    for i := 0; ; i++ {
      out <- i
    }
  }()
  return out
}

// channels, yield-like
func generator_prac() {
  fmt.Println("----------------")
  fmt.Println("generator_prac")
  // Use the generator to produce an infinite stream of numbers
  numbers := generate()
  // Print the first 10 numbers
  for i := 0; i < 10; i++ {
    fmt.Println(<-numbers)
  }
}

func main() {
  comparsion_prac()
  number_prac()
  string_prac()
  list_prac()
  dictionary_prac()
  class_prac()
  map_filter_reduce_prac()
  generator_prac()
}
