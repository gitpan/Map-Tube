#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('White City', 'Victoria');
my @expected = ('White City',
                'Shepherd\'s Bush',
                'Holland Park',
                'Notting Hill Gate',
                'High Street Kensington',
				'Gloucester Road',
                'South Kensington',
                'Sloane Square',
                'Victoria');
ok(eq_array(\@route, \@expected));