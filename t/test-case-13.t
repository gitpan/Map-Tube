#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('South EALING', 'Alperton');
my @expected = ('South Ealing',
                'Acton Town',
                'Ealing Common',
                'North Ealing',
                'Park Royal',
                'Alperton');
ok(eq_array(\@route, \@expected));