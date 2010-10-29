#!perl

use Test::More tests => 7;

use Map::Tube;
my ($map, $got, $expected, @route, $node);
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
    $map->set_node();
};
$got = $@;
$expected = "ERROR: Node is not defined.";
chomp($got);
like($got, qr/$expected/);

# Case 6
$node = ['A','B'];
eval
{
    $map->set_node($node);
};
$got = $@;
$expected = "ERROR: Node has to be a reference to a HASH.";
chomp($got);
like($got, qr/$expected/);

# Case 7
$node = {'A' => {'B' => 'C'}};
eval
{
    $map->set_node($node);
};
$got = $@;
$expected = "ERROR: Member of the node \'A\' has to be a reference to an ARRAY.";
chomp($got);
like($got, qr/$expected/);