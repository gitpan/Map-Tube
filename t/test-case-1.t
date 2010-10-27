#!perl

use Test::More tests => 1;

use Map::Tube;
my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Vauxhall', 'Euston');
my @expected = ('Vauxhall',
				'Pimlico',
				'Victoria',
				'Green Park',
				'Oxford Circus',
				'Warren Street',
				'Euston');
ok(eq_array(\@route, \@expected));