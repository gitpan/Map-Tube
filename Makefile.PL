use ExtUtils::MakeMaker;

WriteMakefile
(
    'NAME'         => 'Map::Tube',
    'VERSION_FROM' => 'lib/Map/Tube.pm',
    'INSTALLDIRS'  => 'site',
    'EXE_FILES'    => [],
    'PL_FILES'     => {}
    'PREREQ_PM'    => {
        'Module::Build' => '0.36',
        'Readonly'      => '0',
        'Test::More'    => '0',
        'Time::HiRes'   => '0'
    }
);