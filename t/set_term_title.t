#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

# BEGIN DO
do "$FindBin::RealBin/../perl/set_term_title";
# END DO

use Test::More;
plan tests => 1;

set_term_title("test for set_term_title");
set_term_title(" ");

pass "set_term_title calls did not fail";

__END__
