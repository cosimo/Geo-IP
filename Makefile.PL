use ExtUtils::MakeMaker;
use Config;

$expat_libpath = '';
$expat_incpath = '';

my @replacement_args;

foreach (@ARGV) {
  if (/^GEOIP(LIB|INC)PATH=(.+)/) {
    if ($1 eq 'LIB') {
      $geoip_libpath = $2;
    }
    else {
      $geoip_incpath = $2;
    }
  }
  else {
    push(@replacement_args, $_);
  }
}

@ARGV = @replacement_args;

if (not $geoip_libpath and $] >= 5.006001) {
  require ExtUtils::Liblist;		# Buggy before this
  ($geoip_libpath) = ExtUtils::Liblist->ext('-lGeoIP');
}

unless ($geoip_libpath) {
  # Test for existence of libGeoIP
  my $found = 0;
  foreach (split(/\s+/, $Config{libpth})) {
    if (-f "$_/libGeoIP." . $Config{so}) {
      $found = 1;
      last;
    }
  }

  unless ($found) {
    die <<'GeoIP_Not_Installed;';

GeoIP must be installed prior to building Geo::IP and I can't find
it in the standard library directories. You can download GeoIP from:

http://geo-ip.com/download/

If expat is installed, but in a non-standard directory, then use the
following options to Makefile.PL:

    GEOIPLIBPATH=...  To set the directory in which to find libGeoIP

    GEOIPINCPATH=...  To set the directory in which to find GeoIP.h

For example:

    perl Makefile.PL GEOIPLIBPATH=/home/me/lib GEOIPINCPATH=/home/me/include

Note that if you build against a shareable library in a non-standard location
you may (on some platforms) also have to set your LD_LIBRARY_PATH environment
variable at run time for perl to find the library.

GeoIP_Not_Installed;
  }
}

@extras = ();

push(@extras,
     CAPI => 'TRUE')
    if ($PERL_VERSION >= 5.005 and $OSNAME eq 'MSWin32'
	and $Config{archname} =~ /-object\b/i);

push(@extras,
     ABSTRACT_FROM => 'lib/Geo/IP.pm',
     AUTHOR        => 'T.J. Mather (tjmather@tjmather.com)')
    if ($ExtUtils::MakeMaker::Version >= 5.4301);
     
WriteMakefile(
              NAME	=> 'Geo::IP',
              dist      => {COMPRESS => 'gzip', SUFFIX => '.gz'},
              VERSION_FROM => 'lib/Geo/IP.pm',
              LIBS      => ['-lGeoIP'],
	      @extras
             );

