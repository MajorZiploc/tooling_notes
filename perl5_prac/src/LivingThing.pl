# these are exported by default.
our @ISA= qw( LivingThing );
our @EXPORT = qw( LivingThing );

package LivingThing;
sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub breathe {
  print "I am breathing\n";
}
