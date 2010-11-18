﻿#!perl

use Test::More tests => 2;

use Map::Tube;

my ($map, $node);
my (@expected, @route);

$map   = Map::Tube->new();
$node = { 1 => [2],
          2 => [1,3,5],
          3 => [2,4],
          4 => [5,3],
          5 => [2,4]};
$map->set_node($node);
@route = $map->get_shortest_route(1, 5);
@expected = (1,2,5);
ok(eq_array(\@route, \@expected));

$node = { 'A' => ['B'],
          'B' => ['A','C','E'],
          'C' => ['B','D'],
          'D' => ['E','C'],
          'E' => ['B','D']};      
$map->set_node($node);
@route = $map->get_shortest_route('A', 'E');
@expected = ('A','B','E');
ok(eq_array(\@route, \@expected));