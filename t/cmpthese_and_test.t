#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use warnings;
use FindBin;

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/cmpthese_and_test";
# END DO
}

sub test1 { return $_[0] + $_[1] }
sub test2 { my $sum = 0; for (@_) { $sum += $_ }; $sum }

# Test::More stuff built into cmpthese_and_test
cmpthese_and_test(
    -0.1,
    test1 => sub {test1(1,2)},
    test2 => sub {test2(1,2)},
);

__END__
