# -*- Mode: Perl; -*-

use strict;
use Test::More;

$^W = 1;

BEGIN { plan tests => 1 }

use Geo::IP;

my $gi;

eval {
    $gi = Geo::IP->open_type(GEOIP_COUNTRY_EDITION_V6);
};

# If no GeoIPv6.dat database is installed,
# we have to skip all the tests
SKIP: {
   
  skip("No GeoIPv6.dat database installed?", 1)
    unless defined $gi;

  while (<DATA>) {
    chomp;
    my ($ipaddr, $exp_country) = split("\t");
    my $country = $gi->country_code_by_addr_v6($ipaddr);
    is(uc($country), $exp_country, "$ipaddr should resolve to '$exp_country'");
  }

}

__DATA__
2a01:e35:8bd9:8bb0:92b:8628:5ca5:5f2b	FR
