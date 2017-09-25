#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: is_in_path.t,v 1.1 2008/02/02 16:55:06 eserte Exp $
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
do "$FindBin::RealBin/../perl/is_in_path";
# END DO
require File::Spec;

plan tests => 3;

ok(is_in_path($^X), "Perl with from \$^X");
ok(!is_in_path("this program does not exist"), "Not existing");
ok(File::Spec->file_name_is_absolute(is_in_path($^X)), "Returned filename is absolute");

__END__
