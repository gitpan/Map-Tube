#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Wembley Central', 'Bond Street');
my @expected = ('Wembley Central',
                'Stonebridge Park',
                'Harlesden',
                'Willesdon Junction',
                'Kensal Green',
                'Queen\'s Park',
                'Kilburn Park',
                'Maida Vale',
                'Warwick Avenue',
                'Paddington',
                'Edgware Road',
                'Baker Street',
                'Bond Street');
ok(eq_array(\@route, \@expected));