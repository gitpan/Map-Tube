#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Wembley Central', 'Bond Street');
my @expected = ('Wembley Central',
                'Stonebridge Park',
                'Harlesden',
                'Willesdon Junction',
                'Shepherd\'s Bush',
                'Holland Park',
                'Notting Hill Gate',
                'Queensway',
                'Lancaster Gate',
                'Marble Arch',
                'Bond Street');
ok(eq_array(\@route, \@expected));