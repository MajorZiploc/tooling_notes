#!/usr/bin/ruby
require_relative "models" #<= require the file
require 'set'
include Models #<= include the module

# single line comment

=begin
 block
 comment
=end

def objects
  puts "-- #{__method__}"
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
  puts "-- #{__method__}"
  $, = ", "
  months = {"1" => "January", "2" => "February"}
  months.default = "This is the default value when a key query doesnt go right"
  keys = months.keys
  puts "keys #{keys}"
  puts "key 22 not in hash map: #{months["22"]}"
end

def iterators
  puts "-- #{__method__}"
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

def fn_with_args (a1, a2)
  puts "-- #{__method__}"
  puts "#{a1} #{a2}"
end

def sets
  puts "-- #{__method__}"
  s1 = Set[1, 2]
  puts "#{s1}"
  s2 = [1, 2].to_set
  puts "#{s2}"
  puts s1 == s2
  s1.add("foo")
  puts "#{s1}"
  s1.merge([2, 6])
  puts "#{s1}"
  puts s1.subset?(s2)
  puts s2.subset?(s1)
  # sets have trouble with objects. it will use the reference hash for comparison by default
  cust1 = Customer.new("Bob", 24)
  cust2 = Customer.new("Sam", 15)
  cust3 = Customer.new("Sam", 15)
  s3 = [cust1, cust2, cust3].to_set
  puts "#{s3.length}"
end

def main
  puts "This is main Ruby Program"
  objects
  dictionaries
  iterators
  fn_with_args 1, 2
  sets
end

END {
  puts "Terminating Ruby Program"
}
BEGIN {
  puts "Initializing Ruby Program"
}

main

