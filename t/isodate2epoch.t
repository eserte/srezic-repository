#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#
# Copyright (C) 2000, 2017 Slaven Rezic.
#

use strict;
use FindBin;
use POSIX 'tzset';
use Test::More;
# BEGIN DO
do "$FindBin::RealBin/../perl/isodate2epoch";
do "$FindBin::RealBin/../perl/epoch2isodate";
# END DO

plan tests => 5;

$ENV{TZ} = 'Europe/Berlin'; tzset;

is isodate2epoch("19701112134500"), 27261900, "parse ISO date";
is isodate2epoch("19701112"),       27212400, "parse ISO date without time part";
is epoch2isodate(27261900), "19701112134500", "epoch2isodate 1";
is epoch2isodate(27212400), "19701112000000", "epoch2isodate 2";
my $now = time;
is isodate2epoch(epoch2isodate($now)), $now,
   "isodate2epoch/epoch2isodate combination";

__END__
