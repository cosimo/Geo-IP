package Geo::IP;

use strict;
use vars qw($VERSION);

use constant COUNTRY_BEGIN => 16776960;

$VERSION = '0.07';

my @countries = ("--","AP","EU","AD","AE","AF","AG","AI","AL","AM","AN","AO","AQ","AR","AS","AT","AU","AW","AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BM","BN","BO","BR","BS","BT","BV","BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CR","CU","CV","CX","CY","CZ","DE","DJ","DK","DM","DO","DZ","EC","EE","EG","EH","ER","ES","ET","FI","FJ","FK","FM","FO","FR","FX","GA","GB","GD","GE","GF","GH","GI","GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT","HU","ID","IE","IL","IN","IO","IQ","IR","IS","IT","JM","JO","JP","KE","KG","KH","KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT","LU","LV","LY","MA","MC","MD","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO","NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS","PT","PW","PY","QA","RE","RO","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SR","ST","SV","SY","SZ","TC","TD","TF","TG","TH","TJ","TK","TM","TN","TO","TP","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY","UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","YE","YT","YU","ZA","ZM","ZR","ZW");

sub new {
  my ($class, $db_file) = @_;
  $db_file ||= '/usr/local/geoip/Geo-IP.dat';
  my $fh;
  open $fh, "$db_file";
  bless {fh => $fh}, $class;
}

sub lookup_country {
  my ($ng, $ip_address) = @_;
  return unless $ip_address =~ m!^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$!;
  return $countries[$ng->_seek_country(0, addr_to_num($ip_address), 31)];
}

sub _seek_country {
  my ($ng, $offset, $ipnum, $depth) = @_;
  my $fh = $ng->{fh};

  if ($depth == 0) {
    die "Error reached 0 depth";
  }

  my ($x0, $x1);
  seek $fh, $offset * 8, 0;
  read $fh, $x0, 4;
  read $fh, $x1, 4;

  $x0 = unpack("I1", $x0);
  $x1 = unpack("I1", $x1);

  if ($ipnum & (1 << $depth)) {
    # go right
    if ($x1 >= COUNTRY_BEGIN) {
      return $x1 - COUNTRY_BEGIN;
    }
    return $ng->_seek_country($x1, $ipnum, $depth - 1);
  } else {
    # go left
    if ($x0 >= COUNTRY_BEGIN) {
      return $x0 - COUNTRY_BEGIN;
    }
    return $ng->_seek_country($x0, $ipnum, $depth - 1);
  }
}

sub lookup_country_by_name {
  my ($ng, $host) = @_;
  my $ip_address;
  if ($host =~ m!^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$!) {
    $ip_address = $host;
  } else {
    $ip_address = join('.',unpack('C4',(gethostbyname($host))[4]));
  }
  return unless $ip_address;
  return $countries[$ng->_seek_country(0, addr_to_num($ip_address), 31)];
}

sub addr_to_num {
  my @a = split('\.',$_[0]);
  return $a[0]*16777216+$a[1]*65536+$a[2]*256+$a[3];
}

1;
__END__

=head1 NAME

Geo::IP - Look up country by IP Address

=head1 SYNOPSIS

  use Geo::IP;

  my $gi = Geo::IP->new('/usr/local/geoip/Geo-IP.dat');

  # look up IP address '65.15.30.247'
  # returns undef if country is unallocated, or not defined in our database
  my $country = $gi->lookup_country('65.15.30.247');
  $country = $gi->lookup_country_by_name('yahoo.com');
  # $country is equal to "US"

=head1 DESCRIPTION

This module uses a file based database.  This database simply contains
IP blocks as keys, and countries as values.  The data is obtained from
the ARIN, RIPE, and APNIC whois servers.  This database should be more
complete and accurate than reverse DNS lookups.

This module can be used to automatically select the geographically closest mirror,
or to target advertising by country, to analyze your web server logs
to determine the countries of your visiters, for credit card fraud
detection, and for software export controls.

To find a country for an IP address, this module a Network
that contains the IP address, then returns the country the Network is
assigned to.

=head1 VERSION

0.07

IP to country database updates available on the first week of each month.  

=head1 AUTHOR

Copyright (c) 2002, T.J. Mather, tjmather@tjmather.com, New York, NY, USA

All rights reserved.  This package is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
