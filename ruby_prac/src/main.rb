#!/usr/bin/ruby
require_relative 'models' # <= require the file
# require "rubygems" # don't need this if you're Ruby v1.9.3 or higher
require 'set'
require 'json'
include Models #<= include the module

# single line comment

=begin
 block
 comment
=end

def objects
  puts "-- #{__method__}"
  cust1 = Customer.new('Bob', 24)
  cust2 = Customer.new('Sam', 15)
  # array/list
  custs = [cust1, cust2]
  # for loop
  for c in custs do
    puts c.say
  end
  string = '{"desc":{"someKey":"someValue","anotherKey":"value"},"main_item":{"stats":{"a":8,"b":12,"c":10}}}'
  parsed = JSON.parse(string) # returns a hash
  puts parsed
end

def dictionaries
  puts "-- #{__method__}"
  $, = ', '
  months = {'1' => 'January', '2' => 'February'}
  months.default = 'This is the default value when a key query doesnt go right'
  keys = months.keys
  puts "keys #{keys}"
  puts "key 22 not in hash map: #{months['22']}"
end

# unpacking dictionary
def dictionaries_splat(x:, y:)
  puts "-- #{__method__}"
  puts "x: #{x}; y: #{y}"
end

def iterators
  puts "-- #{__method__}"
  ary = [1, 2, 3, 4, 5]
  puts 'like a for loop'
  ary.each do |i|
    puts i
  end
  b = ary.collect{ |x| 10 * x }
  puts b
  # appears to be the same as collect i guess?
  c = ary.map{ |x| 10 * x }
  puts c
  # while loop through an array
  array = [1, 2, 3, 4, 5]
  index = 0
  while index < array.length
    puts "while current index: #{index}; array_entry: #{array[index]}"
    index += 1
  end
  # until loop through an array
  index = 0
  until index == array.length
    puts "until current index: #{index}; array_entry: #{array[index]}"
    index += 1
  end
  # do while loop through an array (NOT A GOOD USE CASE OF do while). also this syntax is not recommended for do whiles
  index = 0
  begin
    puts "do while current index: #{index}; array_entry: #{array[index]}"
    index += 1
  end while index < array.length
end

# unpacking array
def array_splat(x, y)
  puts "-- #{__method__}"
  puts "x: #{x}; y: #{y}"
end

def fn_with_args(a1, a2)
  puts "-- #{__method__}"
  puts "#{a1} #{a2}"
end

def sets
  puts "-- #{__method__}"
  s1 = Set[1, 2]
  puts s1.to_s
  s2 = [1, 2].to_set
  puts "#{s2}"
  puts s1 == s2
  s1.add("foo")
  puts s1
  s1.merge([2, 6])
  puts "#{s1}"
  puts s1.subset?(s2)
  puts s2.subset?(s1)
  # sets have trouble with objects. it will use the reference hash for comparison by default
  cust1 = Customer.new('Bob', 24)
  cust2 = Customer.new('Sam', 15)
  cust3 = Customer.new('Sam', 15)
  s3 = [cust1, cust2, cust3].to_set
  puts "#{s3.length}"
end

def strings
  puts "-- #{__method__}"
  haystack = 'saucey boy'
  needle = 'sauce'
  # .includes() .contains()
  r = haystack.include? needle
  puts "'#{haystack}'.include? #{needle} : #{r}"
  # .startsWith()
  r = haystack.start_with? needle
  puts "'#{haystack}'.start_with? #{needle} : #{r}"
  # .endsWith()
  r = haystack.end_with? needle
  puts "'#{haystack}'.end_with? #{needle} : #{r}"
  ## REGEX STUFF
  phone = '2004-959-559 #This is Phone Number'
  # Delete Ruby-style comments: regex sub
  phone = phone.sub!(/#.*$/, '')
  puts "Phone Num : #{phone}"
  # Remove anything other than digits: regex sub
  # regex from string (basic)
  regex_str = '\D'
  phone = phone.gsub!(/#{regex_str}/i, '')
  puts "Phone Num : #{phone}"
  string = 'hello.world'
  regex = Regexp.new(Regexp.escape(string))
  # regex .matches()
  does_match = phone.match?(/#{regex_str}/i)
  puts "phone num matches hello world? #{does_match}"
  # regex .matches()
  r = haystack =~ /Boy/i
  boy = 'Boy'
  # OR with from a string var
  r = haystack =~ /#{boy}/i
  # null check
  puts "'#{haystack}'matches /Boy/i : #{!r.nil?}"
end

def dates
  puts "-- #{__method__}"
  time = Time.new
  puts time
  # date array
  time.to_a
  # July 8, 2008
  time = Time.local(2008, 7, 8)
  puts time
  # July 8, 2008, 09:10am, local time
  time = Time.local(2008, 7, 8, 9, 10)
  puts time
  # July 8, 2008, 09:10 UTC
  time = Time.utc(2008, 7, 8, 9, 10)
  puts time
  # July 8, 2008, 09:10:11 GMT (same as UTC)
  time = Time.gm(2008, 7, 8, 9, 10, 11)
  puts time
  # Returns number of seconds since epoch
  time = Time.now.to_i
  puts time
  # Convert number of seconds into Time object.
  Time.at(time)
  # Returns second since epoch which includes microseconds
  time = Time.now.to_f
  puts time
end

def main
  puts 'This is main Ruby Program'
  objects
  dictionaries
  point = { x: 100, y: 200 }
  dictionaries_splat(**point)
  iterators
  point = [12, 10]
  array_splat(*point)
  fn_with_args 1, 2
  sets
  strings
  dates
end

END {
  puts 'Terminating Ruby Program'
}
BEGIN {
  puts 'Initializing Ruby Program'
}

main

