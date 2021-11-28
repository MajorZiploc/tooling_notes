BEGIN {
  use lib do {
    use Cwd 'realpath';
    my ($dir) = __FILE__ =~ m{^(.*)/};  # $dir = path of current file
    my ($full_path) = realpath("$dir/");            # path of '../lib' relative to $dir
    require "$full_path/LivingThing.pl";
  };
  require List::Util;
  List::Util->import( 'reduce', 'uniq' );
}

# these are exported by default.
our @ISA= qw( Person );
our @EXPORT = qw( Person );

package Person;
our @ISA = qw(LivingThing);
sub new {
  my $class = shift;
  my $name = shift;
  my $ssn = shift;
  my $self = $class->SUPER::new();
  $self->{name} = $name;
  $self->{_ssn} = $ssn;
  bless $self, $class;
  return $self;
}
sub details {
  my $self = shift;
  print "Name is $self->{name}\n";
  print "SSN is $self->{_ssn}\n";
}
