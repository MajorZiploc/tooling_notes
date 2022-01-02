# Applies to perl 5. NOTE: there is a perl 6 out aswell

# single line comment

=begin comment
This is all part of multiline comment.
You can use as many lines as you like
These comments will be ignored by the
compiler until the next =cut is encountered.
=cut

sub multiline_examples {
  # Here Documents
  $a = 10;
$var = <<"EOF";
This is the syntax for here document and it will continue
until it encounters a EOF in the first line.
This is case of double quote so variable value will be
interpolated. For example value of a = $a
EOF
print "$var\n";
$var = <<'EOF';
This is case of single quote so variable value will be
interpolated. For example value of a = $a
EOF
print "$var\n";

  # Multiline strings
  $string = 'This is
  a multiline
  string';
  print "$string\n";
}

sub escape_character_examples {
  # escape character /
  $result = "This is \"number\"";
  print "$result\n";
  print "\$result\n";
}

sub scalar_examples {
  $age = 25;             # An integer assignment
  $name = "John Paul";   # A string
  $salary = 1445.50;     # A floating point
  $mix = $age . " " . $name;    # concatenates string and number.
  print "mix = $mix\n";
  print "Age = $age\n";
  print "Name = $name\n";
  print "Salary = $salary\n";
}

sub array_examples {
  @ages = (25, 30, 40);
  @names = ("John Paul", "Lisa", "Kumar");
  print "\$ages[0] = $ages[0]\n";
  print "\$ages[1] = $ages[1]\n";
  print "\$ages[2] = $ages[2]\n";
  print "\$names[0] = $names[0]\n";
  print "\$names[1] = $names[1]\n";
  print "\$names[2] = $names[2]\n";
}

sub hash_map_examples {
  %data = ('John Paul', 45, 'Lisa', 30, 'Kumar', 40);
  print "\$data{'John Paul'} = $data{'John Paul'}\n";
  print "\$data{'Lisa'} = $data{'Lisa'}\n";
  print "\$data{'Kumar'} = $data{'Kumar'}\n";
}

sub special_literals_examples {
  print "File name ". __FILE__ . "\n";
  print "Line Number " . __LINE__ ."\n";
  print "Package " . __PACKAGE__ ."\n";
  # they can not be interpolated
  print "__FILE__ __LINE__ __PACKAGE__\n";
}

sub ternary_operator_examples {
  $name = "Ali";
  $age = 10;
  $status = ($age > 60 )? "A senior citizen" : "Not a senior citizen";
  print "$name is  - $status\n";
}

sub function_examples {
  # similar to bash args. everything is put into a list
  # 'my' is a way to create a local variable. only usable in lexical scopes with begin end structure
  sub print_list {
    my @list = @_;
    print "Given list is @list\n";
  }
  $a = 10;
  @b = (1, 2, 3, 4);
  # Function call with list parameter
  print_list($a, @b);

  # Function with hash argument. you have to convert the input list to a hash
  sub print_hash {
    my (%hash) = @_;
    foreach my $key ( keys %hash ) {
      my $value = $hash{$key};
      print "$key : $value\n";
    }
  }
  %hash = ('name' => 'Tom', 'age' => 19);
  # Function call with hash parameter
  print_hash(%hash);

  # Function that returns a value
  sub average_fn {
    # get total number of arguments passed.
    $n = scalar(@_);
    $sum = 0;
    foreach $item (@_) {
      $sum += $item;
    }
    $average = $sum / $n;
    return $average;
  }
  # Function call that returns a value
  $num = average_fn(10, 20, 30);
  print "average_fn for the given numbers : $num\n";

  # Local variables - a way to override a global variables value within the lexical scope the local operates in.
  # Global variable
  $string = "Hello, World!";
  sub print_hello {
  # Private variable for print_hello function
  local $string;
  $string = "Hello, Perl!";
  print_me();
  print "Inside the function print_hello $string\n";
  }
  sub print_me {
    print "Inside the function print_me $string\n";
  }
  # Function call
  print_hello();
  print "Outside the function $string\n";

  # state is a way to carry over variable state between a call to the same function
  # python default values of parameters operate in a similar way
  use feature 'state';
  sub print_count {
    state $count = 0; # initial value
    print "Value of counter is $count\n";
    $count++;
  }
  for (1..5) {
    print_count();
  }
}

sub error_examples {
  # die=throw
  # unless is the opposite of if
  unless(chdir("/etc")) {
    die "Error: Can't change directory - $!";
  }
  # bash/react like || && chaining similar to ternary
  # same as
  chdir("/etc") || die "Error: Can't change directory - $!";
  # same as
  !chdir("/etc") && die "Error: Can't change directory - $!";
  # same as
  chdir('/etc') or die "Can't change directory";
  # same as
  !chdir('/etc') and die "Can't change directory";
  # warn is a softer die. it continues execute after the warning
  chdir('/etc') or warn "Can't change directory";
  # for errors in modules look into: carp, cluck, croak, confess
}

sub regex_examples {
  # https://www.tutorialspoint.com/perl/perl_regular_expressions.htm
  $string = "The food is in the salad bar";
  $string =~ m/foo/;
  print "Before: $`\n";
  print "Matched: $&\n";
  print "After: $'\n";
  $string = "The cat sat on the mat";
  $string =~ s/cat/dog/;
  print "$string\n";
  $string = 'The cat sat on the mat';
  $string =~ tr/a/o/;
  print "$string\n";
  # pattern matching to disconstruct capture groups
  $time = "12:05:30";
  $time =~ m/(\d+):(\d+):(\d+)/;
  my ($hours, $minutes, $seconds) = ($1, $2, $3);
  print "Hours : $hours, Minutes: $minutes, Second: $seconds\n";
  # or
  ($hours, $minutes, $seconds) = ($time =~ m/(\d+):(\d+):(\d+)/);
  print "$hours, $minutes, $seconds\n";
}

sub string_cmp_examples {
  $success = "success";
  $fail = "fail";
  $a = "abc";
  $b = "xyz";
  $r = $a ge $b ? $success : $fail;
  print "$r\n";
  $r = $a gt $b ? $success : $fail;
  print "$r\n";
  $r = $a eq $b ? $success : $fail;
  print "$r\n";
  $r = $a ne $b ? $success : $fail;
  print "$r\n";
  $r = $a le $b ? $success : $fail;
  print "$r\n";
  $r = $a lt $b ? $success : $fail;
  print "$r\n";
  $r = $a cmp $b ? $success : $fail;
  print "$r\n";
}

sub main {
  multiline_examples();
  escape_character_examples();
  scalar_examples();
  array_examples();
  hash_map_examples();
  special_literals_examples();
  ternary_operator_examples();
  function_examples();
  error_examples();
  regex_examples();
  string_cmp_examples();
}

main();

