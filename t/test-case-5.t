#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Temple', 'Farringdon');
my @expected = ('Temple',
				'Embankment',
				'Charing Cross',
				'Piccadilly Circus',
				'Oxford Circus',
				'Warren Street',
				'Euston',
				'King\'s Cross St. Pancras',
				'Farringdon');
ok(eq_array(\@route, \@expected));