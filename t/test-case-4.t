#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new({from => 'White City', to => 'Victoria', debug => 0});
my @route = $map->get_shortest_route();
my @expected = ('White City',
				'Shepherd\'s Bush',
				'Holland Park',
				'Notting Hill Gate',
				'Queensway',
				'Lancaster Gate',
				'Marble Arch',
				'Bond Street',
				'Green Park',
				'Victoria');
ok(eq_array(\@route, \@expected));