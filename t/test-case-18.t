#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Baker Street', 'North Harrow');
my @expected = ('Baker Street',
                'Finchley Road',
                'Harrow-on-the-Hill',
                'North Harrow');
ok(eq_array(\@route, \@expected));