#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: apache_virtual_hosts.t,v 1.3 2008/02/04 08:42:57 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/apache_virtual_hosts";
do "$FindBin::RealBin/../perl/is_in_path";
do "$FindBin::RealBin/../perl/file_name_is_absolute";
# END DO
}

BEGIN {
    if (!eval q{
	use Test;
	die "Test only works on Unix" if $^O eq 'MSWin32';
	die "No httpd found in path" if !is_in_path("httpd");
	1;
    }) {
	print join("", map { "# $_\n" } split(/\n/, $@));
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

BEGIN { plan tests => 1 }

my @a = apache_virtual_hosts();
ok(scalar @a > 0, 1);

__END__
