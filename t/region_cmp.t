#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: region_cmp.t,v 1.2 2004/04/08 12:45:42 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test;
	1;
    }) {
	print "# tests only work with installed Test module\n";
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/region_cmp";
# END DO

BEGIN { plan tests => 7 }

ok(region_cmp(1,2,3,4), "before");
ok(region_cmp(3,4,1,2), "after");
ok(region_cmp(1,2,1,2), "equals");
ok(region_cmp(1,2,0,4), "in");
ok(region_cmp(0,4,1,2), "overlaps");
ok(region_cmp(1,2,1,4), "overlaps_before");
ok(region_cmp(2,4,1,2), "overlaps_after");

__END__
