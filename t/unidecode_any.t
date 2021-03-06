#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test::More;
	use Text::Unidecode 1.01; # changed EU -> EUR
	use Encode;
	use charnames qw(:full);
	1;
    }) {
	print "1..0 # skip: no Test::More, Text::Unidecode >=1.01, charnames and/or Encode modules\n";
	exit;
    }
}
use charnames qw(:full);

# BEGIN DO
do "$FindBin::RealBin/../perl/unidecode_any";
# END DO

plan tests => 2;

TODO: {
    todo_skip "Aborts with perl 5.20..5.24", 2 if $] >= 5.020 && $] < 5.026;
    my $x = "" .
	"\N{LATIN CAPITAL LETTER A WITH DIAERESIS}" .
	"\N{LATIN SMALL LETTER A WITH DIAERESIS}" .
	"\N{LATIN CAPITAL LETTER O WITH DIAERESIS}" .
	"\N{LATIN SMALL LETTER O WITH DIAERESIS}" .
	"\N{LATIN CAPITAL LETTER U WITH DIAERESIS}" .
	"\N{LATIN SMALL LETTER U WITH DIAERESIS}" .
	"\x{20ac}\N{HORIZONTAL ELLIPSIS}\N{LEFT DOUBLE QUOTATION MARK}";
    is(unidecode_any($x, "iso-8859-1"), q{������EUR..."});
    is(unidecode_any($x, "ascii"), q{AeaeOeoeUeueEUR..."});
}

__END__
