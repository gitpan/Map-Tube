use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign                => 1,
    module_name         => 'Map::Tube',
    license             => 'perl',
    dist_author         => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from   => 'lib/Map/Tube.pm',
    build_requires => {
        'Test::More'    => 0,
        'Readonly'      => 0,
        'Module::Build' => 0.36,
        'Time::HiRes'   => 0,
    },
    add_to_cleanup      => [ 'Map-Tube-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
