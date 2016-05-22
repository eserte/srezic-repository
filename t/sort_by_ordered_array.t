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
do "$FindBin::RealBin/../perl/sort_by_ordered_array";
# END DO
}

is_deeply [sort_by_ordered_array [qw(foo bla somethingelse elsesomething bar)], [qw(bla bar foo)], fallbackcmp => sub { $_[0] cmp $_[1] }, atend => 0],
          [qw(bla bar foo elsesomething somethingelse)];

is_deeply [sort_by_ordered_array [qw(foo bla somethingelse elsesomething bar)], [qw(bla bar foo)], fallbackcmp => sub { $_[0] cmp $_[1] }, atend => 1],
          [qw(elsesomething somethingelse bla bar foo)];

__END__
