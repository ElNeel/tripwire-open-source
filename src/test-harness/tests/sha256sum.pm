
use twtools;

package sha256sum;

######################################################################
# One time module initialization goes in here...
#
BEGIN {

    $description = "sha256 hash check";
}


######################################################################
#
# Initialize, get ready to run this test...
#
sub initialize() {

  twtools::CreateFile( { file => "test", contents => "deadbeef"x5000} );
}


######################################################################
#
# Run the test.
#
sub run() {

  my $twpassed = 1;

  twtools::logStatus("*** Beginning $description\n");
  printf("%-30s", "-- $description");


  # lets see if the system 'sha256sum' agree's with siggen's sha256 hash
  #
  my ($sha256sum, undef) = split(/ /, `sha256sum $twtools::twrootdir/test`);

  if ($sha256sum eq "") {
      twtools::logStatus("sha256sum not found, trying shasum instead\n");
      ($sha256sum, undef) = split(/ /, `shasum -a 256 $twtools::twrootdir/test`);
  }
  if ($sha256sum eq "") {
      twtools::logStatus("shasum not found, trying openssl instead\n");
      (undef, $sha256sum) = split(/=/, `openssl sha256 $twtools::twrootdir/test`);
  }
  if ($sha256sum eq "") {
      ++$twtools::twskippedtests;
      print "SKIPPED\n";
      return;
  }

  my $siggen = `$twtools::twrootdir/bin/siggen -h -t -2 $twtools::twrootdir/test`;

  chomp $sha256sum;
  chomp $siggen;
  $sha256sum =~ s/^\s+|\s+$//g;
  $siggen =~ s/^\s+|\s+$//g;

  twtools::logStatus("sha256sum reports: $sha256sum\n");
  twtools::logStatus("siggen reports: $siggen\n");

  $twpassed = ($sha256sum eq $siggen);

  #########################################################
  #
  # See if the tests all succeeded...
  #
  if ($twpassed) {
      ++$twtools::twpassedtests;
      print "PASSED\n";
  }
  else {
      ++$twtools::twfailedtests;
      print "*FAILED*\n";
  }
}


######################################################################
# One time module cleanup goes in here...
#
END {
}

1;
