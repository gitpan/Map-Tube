#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Temple', 'Farringdon');
my @expected = ('Temple',
                'Embankment',
                'Waterloo',
                'Bank',
                'Moorgate',
                'Barbican',
                'Farringdon');
ok(eq_array(\@route, \@expected));