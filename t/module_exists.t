#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: module_exists.t,v 1.1 2006/02/01 22:06:17 eserte Exp $
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
do "$FindBin::RealBin/../perl/module_exists";
# END DO

plan tests => 3;

ok(module_exists("Text::ParseWords"), "Existing module");
ok(!module_exists("Foo::Bar::This::Really::Does::Not::Exist"), "Non-existing module");
ok(module_exists("FindBin"), "Exists already in INC");

__END__
