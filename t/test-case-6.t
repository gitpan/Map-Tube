#!perl

use Test::More tests => 1;

use Map::Tube;

my $map   = Map::Tube->new();
my @route = $map->get_shortest_route('Turnham Green', 'Whitechapel');
my @expected = ('Turnham Green',
				'Stamford Brook',
				'Ravenscourt Park',
				'Hammersmith',
				'Barons Court',
				'West Kensington',
				'Earl\'s Court',
				'South Kensington',
				'Sloane Square',
				'Victoria',
				'Green Park',
				'Oxford Circus',
				'Tottenham Court Road',
				'Holborn',
				'Chancery Lane',
				'St. Paul\'s',
				'Bank',
				'Bethnal Green',
				'Mile End',
				'Stepney Green',
				'Whitechapel');
ok(eq_array(\@route, \@expected));