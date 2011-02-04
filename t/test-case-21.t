#!perl

use Test::More tests => 4;

use Map::Tube;

my ($map, @route, @expected);
$map      = Map::Tube->new();
@expected = ('Westferry',
             'Limehouse',
             'Shadwell',
             'Monument',
             'Cannon Street');
			 
@route = $map->get_shortest_route('Westferry', 'Cannon        Street');			 
ok(eq_array(\@route, \@expected));

@route = $map->get_shortest_route('    Westferry', 'Cannon        Street');			 
ok(eq_array(\@route, \@expected));

@route = $map->get_shortest_route('Westferry    ', 'Cannon        Street');			 
ok(eq_array(\@route, \@expected));

@route = $map->get_shortest_route('    Westferry    ', 'Cannon        Street');			 
ok(eq_array(\@route, \@expected));

1;