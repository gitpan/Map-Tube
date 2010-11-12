#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Baker Street', 'Croxley');
my @expected = ('Baker Street',
                'Finchley Road',
                'Harrow-on-the-Hill',
                'Moor Park',
                'Croxley');
ok(eq_array(\@route, \@expected));