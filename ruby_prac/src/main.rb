#!/usr/bin/ruby
require_relative "models" #<= require the file
include Models #<= include the module

# single line comment

=begin
 block
 comment
=end

def objects
  cust1 = Customer.new("Bob", 24)
  cust2 = Customer.new("Sam", 15)
  # array/list
  custs = [cust1, cust2]
  # for loop
  for c in custs do
    puts c.say
  end
  puts "Are their any customers that can drink? #{custs.any? -> (c) { c.age >= 21 }}"
end

def dictionaries
  $, = ", "
  months = {"1" => "January", "2" => "February"}
  months.default = "This is the default value when a key query doesnt go right"
  keys = months.keys
  puts "keys #{keys}"
  puts "key 22 not in hash map: #{months["22"]}"
end

def iterators
  ary = [1,2,3,4,5]
  puts "like a for loop"
  ary.each do |i|
    puts i
  end
  b = ary.collect{|x| 10*x}
  puts b
  # appears to be the same as collect i guess?
  c = ary.map{|x| 10*x}
  puts c
end

def main
  puts "This is main Ruby Program"
  objects
  dictionaries
  iterators
end

END {
  puts "Terminating Ruby Program"
}
BEGIN {
  puts "Initializing Ruby Program"
}

main

