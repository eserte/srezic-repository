#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: catfile.t,v 1.2 2004/04/08 12:45:42 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

# BEGIN DO
do "$FindBin::RealBin/../perl/catfile";
# END DO

BEGIN {
    if (!eval q{
	use Test;
	die "Test only works on Unix" if $^O eq 'MSWin32';
	1;
    }) {
	print join("", map { "# $_\n" } split(/\n/, $@));
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

BEGIN { plan tests => 1 }

ok(catfile("bla", "blubber"), "bla/blubber");

__END__
