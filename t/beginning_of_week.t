#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: beginning_of_week.t,v 1.1 2004/03/24 21:58:29 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 2000 Onlineoffice. All rights reserved.
#

use Test;
use Time::Local;
# BEGIN DO
do "../perl/beginning_of_week";
do "../perl/end_of_week";
do "../perl/beginning_of_month";
do "../perl/end_of_month";
do "../perl/leapyear";
# END DO

BEGIN { plan tests => 4+12+4 }

my $first_day = timelocal(0,0,12,4,6,100);

my @l = localtime beginning_of_week($first_day);
ok(join(",",@l[0..5]), join(",",0,0,0,3,6,100), "beginning_of_week failed");

@l = localtime end_of_week($first_day);
ok(join(",",@l[0..5]), join(",",59,59,23,9,6,100), "end_of_week failed");

@l = localtime beginning_of_month($first_day);
ok(join(",",@l[0..5]), join(",",0,0,0,1,6,100), "beginning_of_month failed");

@l = localtime end_of_month($first_day);
ok(join(",",@l[0..5]), join(",",59,59,23,31,6,100), "end_of_month for July failed");

my @month_len = (31,29,31,30,31,30,31,31,30,31,30,31);
my $time_i = end_of_month(timelocal(59,59,23,31,11,99));
for (1 .. 12) {
    $time_i++;
    $time_i = end_of_month($time_i);
    @l = localtime $time_i;
    ok(join(",",@l[0..5]), join(",",59,59,23,$month_len[$_-1],$_-1,100),
       "end_of_month for month $_ failed");
}

ok(leapyear(2000),1,"leapyear for 2000 failed");
ok(leapyear(1999),"","leapyear for 1999 failed");
ok(leapyear(1996),1,"leapyear for 1996 failed");
ok(leapyear(1900),"","leapyear for 1900 failed");

__END__
