#!perl

use Test::More tests => 14;

use Map::Tube;
my ($map, $got, $expected, @route, $node);

# Case 1
eval
{
    $map = Map::Tube->new('a');
};
$got = $@;
$expected = "ERROR: Only valid argument to the constructor is 1 or 0.";
chomp($got);
like($got, qr/$expected/);

# Case 2
eval
{
    $map = Map::Tube->new(2);
};
$got = $@;
$expected = "ERROR: Only valid argument to the constructor is 1 or 0.";
chomp($got);
like($got, qr/$expected/);

$map = Map::Tube->new();

# Case 3
eval
{
    @route = $map->get_shortest_route();
};
$got = $@;
$expected = "ERROR: Either FROM/TO node is undefined.";
chomp($got);
like($got, qr/$expected/);

# Case 4
eval
{
    @route = $map->get_shortest_route('Bond Street');
};
$got = $@;
$expected = "ERROR: Either FROM/TO node is undefined.";
chomp($got);
like($got, qr/$expected/);

# Case 5
eval
{
    @route = $map->get_shortest_route('XYZ', 'Bond Street');
};
$got = $@;
$expected = "ERROR: Received invalid FROM node XYZ.";
chomp($got);
like($got, qr/$expected/);

# Case 6
eval
{
    @route = $map->get_shortest_route('Bond Street', 'XYZ');
};
$got = $@;
$expected = "ERROR: Received invalid TO node XYZ.";
chomp($got);
like($got, qr/$expected/);

# Case 7
eval
{
    $map->set_node();
};
$got = $@;
$expected = "ERROR: Node is not defined.";
chomp($got);
like($got, qr/$expected/);

# Case 8
$node = ['A','B'];
eval
{
    $map->set_node($node);
};
$got = $@;
$expected = "ERROR: Node has to be a reference to a HASH.";
chomp($got);
like($got, qr/$expected/);

# Case 9
$node = {'A' => {'B' => 'C'}};
eval
{
    $map->set_node($node);
};
$got = $@;
$expected = "ERROR: Member of the node \'A\' has to be a reference to an ARRAY.";
chomp($got);
like($got, qr/$expected/);

# Case 10
$node = { 'A' => ['B','C'],
          'B' => ['C','A'] };
$map->set_node($node);
$name = $map->get_name('A');
$expected = 'A';
like($name, qr/$expected/);

# Case 11
eval
{
    $name = $map->get_name('X');
};
$got = $@;
$expected = "ERROR: Invalid node code 'X'.";
chomp($got);
like($got, qr/$expected/);

# Case 12
eval
{
    $name = $map->get_name();
};
$got = $@;
$expected = "ERROR: Code is not defined.";
chomp($got);
like($got, qr/$expected/);

# Case 13
$map->set_default_node();
$name = $map->get_name('BST');
$expected = 'Baker Street';
like($name, qr/$expected/);

# Case 14
eval
{
    $name = $map->get_name();
};
$got = $@;
$expected = "ERROR: Code is not defined.";
chomp($got);
like($got, qr/$expected/);