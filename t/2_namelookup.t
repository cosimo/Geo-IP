use strict;
use Test;

$^W = 1;

BEGIN { plan tests => 20 }

use Geo::IP;

my $gi = new Geo::IP;

while (<DATA>) {
  chomp;
  my ($host, $exp_country) = split("\t");
  my $country = $gi->lookup_country_by_name($host);
  ok($country, $exp_country);
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
yahoo.com	US
www.bundesregierung.de	DE
www.thaigov.go.th	TH
www.president.ir	IR
www.moinfo.gov.kw	KW
www.gov.ru	RU
www.parliament.ge	GE
www.cpv.org.vn	VN
alfa.nic.in	IN
