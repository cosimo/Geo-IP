
use DB_File;

unless ($ARGV[0]){
  print STDERR "usage: $0 filename\n";
  exit;
}

my $file = $ARGV[0];

die "could not load $file.dat" unless (-e "$file.dat");
die "$file.db already exists - move out of the way" if (-e "$file.db");

tie %hash, 'DB_File', "$file.db", O_CREAT, 0666, $DB_BTREE;

open DATA, "$file.dat";
my ($ip_network_block, $country);
while(1){
  # read IP network block
  unless ((my $bytes_read = read DATA, $ip_network_block, 5) == 5){
    if ($bytes_read > 0){
      die "Error reading input file $file.dat";
    }
    last;
  }
  my $bytes_read = read DATA, $country, 2;
  unless ($bytes_read == 2){
    die "Error reading input file $file.dat";
  }
  $hash{$ip_network_block} = $country;
}

close DATA;

untie %hash;
