#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new({from => 'Bond Street', to => 'Euston'});
my @route = $map->get_shortest_route();
my @expected = ('Bond Street',
				'Oxford Circus',
				'Warren Street',
				'Euston');
ok(eq_array(\@route, \@expected));