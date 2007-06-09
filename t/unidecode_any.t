#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: unidecode_any.t,v 1.2 2007/06/09 19:23:58 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test::More;
	use Text::Unidecode;
	use Encode;
	use charnames qw(:full);
	1;
    }) {
	print "1..0 # skip: no Test::More, Text::Unidecode, charnames and/or Encode modules\n";
	exit;
    }
}
use charnames qw(:full);

# BEGIN DO
do "$FindBin::RealBin/../perl/unidecode_any";
# END DO

plan tests => 2;

my $x = "" .
    "\N{LATIN CAPITAL LETTER A WITH DIAERESIS}" .
    "\N{LATIN SMALL LETTER A WITH DIAERESIS}" .
    "\N{LATIN CAPITAL LETTER O WITH DIAERESIS}" .
    "\N{LATIN SMALL LETTER O WITH DIAERESIS}" .
    "\N{LATIN CAPITAL LETTER U WITH DIAERESIS}" .
    "\N{LATIN SMALL LETTER U WITH DIAERESIS}" .
    "\x{20ac}\N{HORIZONTAL ELLIPSIS}\N{LEFT DOUBLE QUOTATION MARK}";
is(unidecode_any($x, "iso-8859-1"), q{ÄäÖöÜüEU..."});
is(unidecode_any($x, "ascii"), q{AeaeOeoeUeueEU..."});

__END__
