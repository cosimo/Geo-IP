use ExtUtils::MakeMaker;
use DB_File;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Geo::IP',
    'VERSION_FROM' => 'lib/Geo/IP.pm', # finds $VERSION
    'EXE_FILES' => ['geoip-lookup'],
);
