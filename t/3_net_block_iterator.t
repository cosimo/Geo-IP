use strict;
use Test;

$^W = 1;

BEGIN { plan tests => 5 }

use Geo::IP;

my $gi = new Geo::IP('Geo-IP.db');

my $iterator = $gi->_net_block_iterator('192.168.42.153');

my @ip_array;

while(my $bin_ip = $iterator->()){
	push @ip_array, join(".",unpack("C5",$bin_ip));
}
ok($ip_array[0] eq "192.168.42.153.32");
ok($ip_array[5] eq "192.168.42.128.27");
ok($ip_array[10] eq "192.168.40.0.22");
ok($ip_array[15] eq "192.168.0.0.17");
ok($ip_array[20] eq "192.160.0.0.12");
