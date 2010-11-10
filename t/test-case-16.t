#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Westferry', 'Cannon Street');
my @expected = ('Westferry',
                'Limehouse',
                'Shadwell',
                'Monument',
                'Cannon Street');
ok(eq_array(\@route, \@expected));

1;