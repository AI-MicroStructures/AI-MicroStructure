#!/usr/bin/perl -X
package AI::MicroStructure::List;
use strict;
use AI::MicroStructure (); # do not export microname and friends
use AI::MicroStructure::RemoteList;
use List::Util qw( shuffle );
use Carp;

our @ISA = qw( AI::MicroStructure::RemoteList );

sub init {
    my ($self, $data) = @_;
    my $class = caller(0);

    $data ||= AI::MicroStructure->load_data($class);
    croak "The optional argument to init() must be a hash reference"
      if ref $data ne 'HASH';

    no strict 'refs';
    no warnings;
    ${"$class\::structure"} = ( split /::/, $class )[-1];
    @{"$class\::List"} = split /\s+/, $data->{names};
    *{"$class\::import"} = sub {
        my $callpkg = caller(0);
        my $structure   = ${"$class\::structure"};
        my $micro    = $class->new();
        *{"$callpkg\::micro$structure"} = sub { $micro->name(@_) };
      };
    ${"$class\::micro"} = $class->new();
}

sub name {
    my ( $self, $count ) = @_;
    my $class = ref $self;

    if( ! $class ) { # called as a class method!
        $class = $self;
        no strict 'refs';
        $self = ${"$class\::micro"};
    }
	no strict 'refs';

    if( defined $count){
    if ($count == 0 ) {
        return
          wantarray ? shuffle @{"$class\::List"} : scalar @{"$class\::List"};
    }
    }
    $count ||= 1;
    my $list = $self->{cache};
    {
      no strict 'refs';
      if (@{"$class\::List"}) {
          push @$list, shuffle @{"$class\::List"} while @$list < $count;
      }
    }
    splice( @$list, 0, $count );
}

sub new {
    my $class = shift;

    bless { cache => [] }, $class;
}

sub structure {
    my $class = ref $_[0] || $_[0];
    no strict 'refs';
    return ${"$class\::structure"};
}




1;

__END__

