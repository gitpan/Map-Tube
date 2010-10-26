#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new({from => 'Wembley Central', to => 'Bond Street', debug => 0});
my @route = $map->get_shortest_route();
my @expected = ('Wembley Central','Stonebridge Park','Harlesden','Willesdon Junction','Kensal Green','Queen\'s Park','Kilburn Park','Maida Vale','Warwick Avenue','Paddington','Edgware Road','Marleybone','Baker Street','Bond Street');
ok(eq_array(\@route, \@expected));