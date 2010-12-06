#!perl

use Test::More tests => 1;

use Map::Tube;

my $map  = Map::Tube->new();
my $mappings = { 'A' => ['B','F','G'],
                 'B' => ['A','C','G'],
                 'C' => ['B','D','G'],
                 'D' => ['C','E','G'],
                 'E' => ['D','F','G'],
                 'F' => ['A','E','G','H'],
                 'G' => ['A','B','C','D','E','F'],
                 'H' => ['F','I'],
                 'I' => ['H'],};
$map->set_node_mappings($mappings);
@route = $map->get_shortest_route('C', 'H');
my @expected = ('C','G','F','H');
ok(eq_array(\@route, \@expected));