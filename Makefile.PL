use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Geo::IP',
    'VERSION_FROM' => 'lib/Geo/IP.pm', # finds $VERSION
    'PREREQ_PM' => {DB_File => 0},
);
