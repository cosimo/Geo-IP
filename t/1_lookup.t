use strict;
use Test;

$^W = 1;

BEGIN { plan tests => 19 }

use Geo::IP;

my $gi = Geo::IP->new('/usr/local/geoip/Geo-IP.dat');

while (<DATA>) {
  chomp;
  my ($ipaddr, $exp_country) = split("\t");
  my $country = $gi->lookup_country($ipaddr);
  ok(uc($country), $exp_country);
}

__DATA__
203.174.65.12	JP
212.208.74.140	FR
200.219.192.106	BR
65.15.30.247	US
134.102.101.18	DE
193.75.148.28	BE
134.102.101.18	DE
147.251.48.1	CZ
194.244.83.2	IT
203.15.106.23	AU
196.31.1.1	ZA
210.54.22.1	NZ
210.25.5.5	CN
210.54.122.1	NZ
210.25.15.5	CN
192.37.51.100	CH
192.37.150.150	CH
192.106.51.100	IT
192.106.150.150	IT
