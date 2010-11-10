#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Wembley Central', 'Marleybone');
my @expected = ('Wembley Central',
                'Stonebridge Park',
                'Harlesden',
                'Willesdon Junction',
                'Shepherd\'s Bush',
                'Holland Park',
                'Notting Hill Gate',
                'Bayswater',
                'Edgware Road',
                'Marleybone');
ok(eq_array(\@route, \@expected));