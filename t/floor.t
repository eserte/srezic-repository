#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: floor.t,v 1.1 2004/03/24 21:58:29 eserte Exp $
# Author: Slaven Rezic
#

use strict;

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
do "../perl/floor";
# END DO

BEGIN { plan tests => 5 }

ok(floor(0), 0);
ok(floor(1), 1);
ok(floor(1.1), 1);
ok(floor(-1), -1);
ok(floor(-1.1), -2);

__END__
