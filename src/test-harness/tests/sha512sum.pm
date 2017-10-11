
use twtools;

package sha512sum;

######################################################################
# One time module initialization goes in here...
#
BEGIN {

    $description = "sha512 hash check";
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


  # lets see if the system 'sha512sum' agree's with siggen's sha512 hash
  #
  my ($sha512sum, undef) = split(/ /, `sha512sum $twtools::twrootdir/test`);
  if ($sha512sum eq "") {
      twtools::logStatus("sha512sum not found, trying shasum instead\n");
      ($sha512sum, undef) = split(/ /, `shasum -a 512 $twtools::twrootdir/test`);
  }
  if ($sha512sum eq "") {
      twtools::logStatus("shasum not found, trying openssl instead\n");
      (undef, $sha512sum) = split(/=/, `openssl sha512 $twtools::twrootdir/test`);
  }
  if ($sha512sum eq "") {
      ++$twtools::twskippedtests;
      print "SKIPPED\n";
      return;
  }

  my $siggen = `$twtools::twrootdir/bin/siggen -h -t -5 $twtools::twrootdir/test`;

  chomp $sha512sum;
  chomp $siggen;
  $sha512sum =~ s/^\s+|\s+$//g;
  $siggen =~ s/^\s+|\s+$//g;

  twtools::logStatus("sha512sum reports: $sha512sum\n");
  twtools::logStatus("siggen reports: $siggen\n");

  $twpassed = ($sha512sum eq $siggen);

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
