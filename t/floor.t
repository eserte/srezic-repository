#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: floor.t,v 1.2 2004/04/08 12:45:42 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test;
	1;
    }) {
	print "1..0 # skip: no Test module\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/floor";
# END DO

BEGIN { plan tests => 5 }

ok(floor(0), 0);
ok(floor(1), 1);
ok(floor(1.1), 1);
ok(floor(-1), -1);
ok(floor(-1.1), -2);

__END__
