#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: isodate2epoch.t,v 1.1 2004/03/24 21:58:30 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 2000 Onlineoffice. All rights reserved.
#

use Test;
# BEGIN DO
do "../perl/isodate2epoch";
do "../perl/epoch2isodate";
# END DO

BEGIN { plan tests => 5 }

ok(isodate2epoch("19701112134500"), 27261900, "Can't parse ISO date");
ok(isodate2epoch("19701112"),       27212400, "Can't parse ISO date without time part");
ok(epoch2isodate(27261900), "19701112134500", "epoch2isodate failure 1");
ok(epoch2isodate(27212400), "19701112000000", "epoch2isodate failure 2");
my $now = time;
ok(isodate2epoch(epoch2isodate($now)), $now,
   "Failure in isodate2epoch/epoch2isodate combination");

__END__
