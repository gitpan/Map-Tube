#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Hoxton', 'Gospel Oak');
my @expected = ('Hoxton',
                'Haggerston',
                'Dalston Junction',
                'Dalston Kingsland',
                'Canonbury',
                'Highbury & Islington',
                'Caledonian Road & Barnsbury',
                'Camden Road',
                'Kentish Town West',
                'Gospel Oak');
ok(eq_array(\@route, \@expected));

1;