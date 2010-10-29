#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Oval', 'Euston');
my @expected = ('Oval',
				'Kennington',
				'Waterloo',
				'Westminster',
				'Green Park',
				'Oxford Circus',
				'Warren Street',
				'Euston');
ok(eq_array(\@route, \@expected));