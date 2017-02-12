#!/usr/bin/perl -w
# -*- cperl -*-

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
do "$FindBin::RealBin/../perl/missing_deb_packages";
do "$FindBin::RealBin/../perl/is_in_path";
do "$FindBin::RealBin/../perl/file_name_is_absolute";
# END DO


plan skip_all => "Not on linux" if $^O ne 'linux';
plan skip_all => "Probably not a Debian system" if !is_in_path('dpkg-query');

plan 'no_plan';

{
    my @missing = missing_deb_packages('this-does-not-exist');
    is_deeply \@missing, [qw(this-does-not-exist)];
}

{
    my @missing = missing_deb_packages('dpkg');
    is_deeply \@missing, [];
}

__END__
