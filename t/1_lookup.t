use strict;
use Test;

$^W = 1;

BEGIN { plan tests => 11 }

use Geo::IP;

my $gi = new Geo::IP('./Geo-IP-Perl_200106.db');

my $country = $gi->lookup_country('203.174.65.12');
ok($country eq "JP");
$country = $gi->lookup_country('212.208.74.140');
ok($country eq "FR");
$country = $gi->lookup_country('200.219.192.106');
ok($country eq "BR");
$country = $gi->lookup_country('65.15.30.247');
ok($country eq "US");
$country = $gi->lookup_country('134.102.101.18');
ok($country eq "DE");
$country = $gi->lookup_country('193.75.148.28');
ok($country eq "EU");
$country = $gi->lookup_country('134.102.101.18');
ok($country eq "DE");
$country = $gi->lookup_country('147.251.48.1');
ok($country eq "CZ");
$country = $gi->lookup_country('194.244.83.2');
ok($country eq "IT");
$country = $gi->lookup_country('203.15.106.23');
ok($country eq "AU");
$country = $gi->lookup_country('196.31.1.1');
ok($country eq "ZA");
