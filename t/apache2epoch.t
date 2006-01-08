#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: apache2epoch.t,v 1.1 2006/01/08 21:29:22 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;
use Time::Local;

BEGIN {
    if (!eval q{
	use Test::More;
	1;
    }) {
	print "1..0 # skip: no Test::More module\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/apache2epoch";
# END DO

plan tests => 2;

is(apache2epoch("21/Jul/2003:21:30:19 +0200"),
   timegm(19,30,21-2,21,7-1,2003), "DST");
is(apache2epoch("08/Jan/2006:22:20:17 +0100"),
   timegm(17,20,22-1,8,1-1,2006), "No DST");

__END__
