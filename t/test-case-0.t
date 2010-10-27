#!perl

use Test::More tests => 4;

use Map::Tube;
my ($map, $got, $expected, @route);
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