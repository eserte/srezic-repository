#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;
use Test::More 'no_plan';

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/sort_by_example";
# END DO
}

is_deeply [sort_by_example [qw(bla bar foo)], qw(foo bla somethingelse elsesomething bar)],
          [qw(bla bar foo elsesomething somethingelse)];

__END__
