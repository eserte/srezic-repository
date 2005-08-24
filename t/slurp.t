#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: slurp.t,v 1.1 2005/08/24 21:41:32 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

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
do "$FindBin::RealBin/../perl/slurp";
# END DO

plan tests => 2;

my $contents = slurp(__FILE__);
ok(defined $contents);

eval {
    slurp(__FILE__ . "XXXdoesnotexistXXX");
};
cmp_ok($@, "ne", "");

__END__
