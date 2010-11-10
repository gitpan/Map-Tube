#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Bank', 'Westminster');
my @expected = ('Bank',
                'Waterloo',
                'Westminster');
ok(eq_array(\@route, \@expected));

1;