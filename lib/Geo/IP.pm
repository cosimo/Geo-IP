package Geo::IP;

use strict;
use vars qw($VERSION);

use DB_File;

$VERSION = '0.02';

sub new {
  my ($class, $db_file) = @_;
  my %hash = ();
  tie %hash, 'DB_File', $db_file, O_CREAT|O_RDWR, 0666, $DB_BTREE;
  bless {db_hash => \%hash}, $class;
}

sub lookup_country {
  my ($ng, $ip_address) = @_;
  my $iterator = $ng->_net_block_iterator($ip_address);
  while(my $bin_block = $iterator->()){
    next unless exists $ng->{db_hash}->{$bin_block};
    return $ng->{db_hash}->{$bin_block};
  }
  return undef;
}

sub _binary_ip {
  my ($ng, $ip_address) = @_;
  my @blocks = split('\.',$ip_address);
  my $binary_ip = pack "C4", @blocks;
  return $binary_ip;
}

# return iterator object that returns binary representation
sub _net_block_iterator {
  # start with 32 blocks
  my ($ng, $ip_address) = @_;
  my $binary_ip = $ng->_binary_ip($ip_address);
  my $block = 32;
  return sub {
    return if $block < 3;
    my $bit_block = pack "B32", ('1' x $block);
    my $new_ip = $binary_ip & $bit_block;
    my $bin_block = $new_ip . pack "C1", $block;
    $block--;
    return $bin_block;
  }
}

1;
__END__

=head1 NAME

Geo::IP - Look up country by IP Address

=head1 SYNOPSIS

  use Geo::IP;

  my $gi = new Geo::IP('/path/to/db/Net-Geography-Perl_200106.db');

  # look up IP address '65.15.30.247'
  # returns undef if country is unallocated, or not defined in our database
  my $country = $gi->lookup_country('65.15.30.247');
  # $country is equal to "US"

=head1 DESCRIPTION

This module uses the Berkeley database.  This database simply contains
IP blocks as keys, and countries as values.  The data is obtained from
the ARIN, RIPE, and APNIC whois servers.  This database should be more
complete and accurate than reverse DNS lookups.

This module can be used to automatically select the geographically closest mirror,
or to target advertising by country, to analyze your web server logs
to determine the countries of your visiters, for credit card fraud
detection, and for software export controls.

To find a country for an IP address, this module finds Networks
that contain the IP address, starting with a netmask of 32, going up to
3 until it finds a matching IP Block.

=head1 VERSION

0.02

IP to country database available from http://www.geo-ip.com
Up-to-date as of June 1st, 2001

Updates to the database should come out monthly.  Look for updates
at http://www.geo-ip.com

=head1 AUTHOR

Copyright (c) 2001, T.J. Mather, tjmather@tjmather.com

All rights reserved.  This package is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
