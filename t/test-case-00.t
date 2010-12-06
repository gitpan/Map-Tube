#!perl

use Test::More tests => 13;

use Map::Tube;
my ($map, $got, $expected, @route, $mappings);

$map = Map::Tube->new();

# Case 1
eval
{
    @route = $map->get_shortest_route();
};
$got = $@;
$expected = "ERROR: Either FROM/TO node is undefined.";
chomp($got);
like($got, qr/$expected/);

# Case 2
eval
{
    @route = $map->get_shortest_route('Bond Street');
};
$got = $@;
$expected = "ERROR: Either FROM/TO node is undefined.";
chomp($got);
like($got, qr/$expected/);

# Case 3
eval
{
    @route = $map->get_shortest_route('XYZ', 'Bond Street');
};
$got = $@;
$expected = "ERROR: Received invalid FROM node XYZ.";
chomp($got);
like($got, qr/$expected/);

# Case 4
eval
{
    @route = $map->get_shortest_route('Bond Street', 'XYZ');
};
$got = $@;
$expected = "ERROR: Received invalid TO node XYZ.";
chomp($got);
like($got, qr/$expected/);

# Case 5
eval
{
    $map->set_node_mappings();
};
$got = $@;
$expected = "ERROR: Node mapping is undefined.";
chomp($got);
like($got, qr/$expected/);

# Case 6
$mappings = ['A','B'];
eval
{
    $map->set_node_mappings($mappings);
};
$got = $@;
$expected = "ERROR: Node has to be a reference to a HASH.";
chomp($got);
like($got, qr/$expected/);

# Case 7
$mappings = {'A' => {'B' => 'C'}};
eval
{
    $map->set_node_mappings($mappings);
};
$got = $@;
$expected = "ERROR: Member of the node \'A\' has to be a reference to an ARRAY.";
chomp($got);
like($got, qr/$expected/);

# Case 8
$mappings = { 'A' => ['B','C'],
              'B' => ['C','A'],
              'C' => ['A','B'],};
$map->set_node_mappings($mappings);
$name = $map->get_node_name('A');
$expected = 'A';
like($name, qr/$expected/);

# Case 9
eval
{
    $name = $map->get_node_name('X');
};
$got = $@;
$expected = "ERROR: Invalid node code 'X'.";
chomp($got);
like($got, qr/$expected/);

# Case 10
eval
{
    $name = $map->get_node_name();
};
$got = $@;
$expected = "ERROR: Code is not defined.";
chomp($got);
like($got, qr/$expected/);

# Case 11
$map->set_default_node_mappings();
$name = $map->get_node_name('BST');
$expected = 'Baker Street';
like($name, qr/$expected/);

# Case 12
eval
{
    $name = $map->get_node_name();
};
$got = $@;
$expected = "ERROR: Code is not defined.";
chomp($got);
like($got, qr/$expected/);

# Case 13
$mappings = { 'A' => ['B','F','G'],
              'B' => ['A','C','G'],
              'C' => ['B','D','G'],
              'D' => ['C','E','G'],
              'E' => ['D','F','G'],
              'F' => ['A','E','G','H'],
              'G' => ['A','B','C','D','E','F'],
              'H' => ['F','I']};
eval
{          
    $map->set_node_mappings($mappings);
};
$got = $@;
$expected = "ERROR: Missing map definitions for 'I'.";
chomp($got);
like($got, qr/$expected/);