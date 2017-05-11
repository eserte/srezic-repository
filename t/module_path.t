#!/usr/bin/perl -w
# -*- perl -*-

#
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
do "$FindBin::RealBin/../perl/module_path";
# END DO

plan tests => 2;

ok(module_path("Text::ParseWords"), "Existing module");
is(module_path("Foo::Bar::This::Really::Does::Not::Exist"), undef, "Non-existing module");

__END__
