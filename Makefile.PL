use ExtUtils::MakeMaker;
use DB_File;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Geo::IP',
    'VERSION_FROM' => 'lib/Geo/IP.pm', # finds $VERSION
    'PREREQ_PM' => {DB_File => 0,
		LWP::UserAgent => 0},
    'PPM_INSTALL_SCRIPT' => 'installdb',
    'EXE_FILES' => ['geoip-lookup'],
);

# download 
unless (-f "Geo-IP.db") {
  eval {require LWP::UserAgent }
    or die "You do not have LWP::UserAgent installed, cannot download, exiting...";

  $ua = new LWP::UserAgent;
  $request = new HTTP::Request('GET', 'http://geo-ip.com/download/Geo-IP.dat.gz');
  print "Downloading http://geo-ip.com/download/Geo-IP.dat.gz\n";
  $response = $ua->simple_request($request,'Geo-IP.dat.gz') || die 'failed to download http://geo-ip.com/download/Geo-IP.dat.gz';

  print "Unziping Geo-IP.dat.gz\n";
  @args = ("gunzip", "Geo-IP.dat.gz");
  system(@args) == 0
     or die "system @args failed: $?";

  print "Creating Berkeley Database Geo-IP.db\n";
  # O_RDWR for IRIX compatibility
  tie %hash, 'DB_File', "Geo-IP.db", O_RDWR|O_CREAT, 0666, $DB_BTREE ||
    die "Failed to create Berkeley Database file Geo-IP.db";

  open DATA, "Geo-IP.dat";
  # for windows compatibility
  binmode DATA;
  my ($ip_network_block, $country);
  while(1){
    # read IP network block
    unless ((my $bytes_read = read DATA, $ip_network_block, 5) == 5){
      if ($bytes_read > 0){
        die "Error reading input file Geo-IP.dat";
      }
      last;
    }
    my $bytes_read = read DATA, $country, 2;
    unless ($bytes_read == 2){
      die "Error reading input file Geo-IP.dat";
    }
    $hash{$ip_network_block} = $country;
  }
  close DATA;
  untie %hash;
}

sub MY::install {
  package MY; # so that "SUPER" works right
  my $install = shift->SUPER::install(@_);
  $install =~ s!(install :: (.*?)\n)!$1\tmkdir /usr/local/geoip && cp Geo-IP.db /usr/local/geoip/\n!;
  return $install;
}
