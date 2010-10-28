#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Baker Street', 'Preston Road');
my @expected = ('Baker Street',
				'Finchley Road',
				'Wembley Park',
				'Preston Road');
ok(eq_array(\@route, \@expected));