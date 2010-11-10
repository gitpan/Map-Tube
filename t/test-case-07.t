#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Goldhawk Road', 'Wembley Central');
my @expected = ('Goldhawk Road',
                'Shepherd\'s Bush Market',
                'Wood Lane',
                'White City',
                'Shepherd\'s Bush',
                'Willesdon Junction',
                'Harlesden',
                'Stonebridge Park',
                'Wembley Central');
ok(eq_array(\@route, \@expected));