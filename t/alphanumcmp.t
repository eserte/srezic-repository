#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: alphanumcmp.t,v 1.1 2004/03/24 21:58:30 eserte Exp $
# Author: Slaven Rezic
#

use strict;

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
do "../perl/alphanumcmp";
# END DO

BEGIN { plan tests => 6 }

my %cmp = (-1 => '<',
	   0  => '=',
	   '' => '=',
	   +1 => '>');

foreach (["S1", "S10", -1],
	 ["R12", "S12",-1],
	 ["S45", "S4", +1],
	 ["a", "a", 0],
	 ["abc", "cba12", -1],
	 ["12a", "1a", +1],
	) {
    my $cmp = alphanumcmp($_->[0], $_->[1]);
    ok($cmp,$_->[2],"Unexpected compare result $cmp for $_->[0] <=> $_->[1]");
}

__END__
