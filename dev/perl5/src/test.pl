use strict;
use warnings;
use Test::More tests => 3;

# test equality
is(2 + 2, 4, '2 + 2 equals 4');

# test regular expression match
like('Hello, world!', qr/world/, 'string contains "world"');

# test exception handling
dies_ok { die "Error!" } 'exception thrown';
