#!perl -T

use Test::More tests => 1;

use Map::Tube::Node;

BEGIN {
    use_ok( 'Map::Tube' ) || print "Bail out!
";
}

diag( "Testing Map::Tube $Map::Tube::VERSION, Perl $], $^X" );
