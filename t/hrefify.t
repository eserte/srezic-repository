#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: hrefify.t,v 1.2 2005/12/12 23:57:19 eserte Exp $
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
do "$FindBin::RealBin/../perl/hrefify";
# END DO

use charnames ':full';

BEGIN { plan tests => 4 }

for my $test (["http://www/only", qq{<a href="http://www/only">http://www/only</a>}],
	      ["s�me http://www/bla before and �fter", qq{s&#xF6;me <a href="http://www/bla">http://www/bla</a> before and &#xE4;fter}],
	      ["no �rl at all", "no &#xFC;rl at all"],
	      ["<&>'\"\N{EURO SIGN}", "&#x3C;&#x26;&#x3E;&#x27;&#x22;&#x20AC;"],
	     ) {
    my($text, $expect) = @$test;
    is(hrefify($text), $expect);
}


__END__
