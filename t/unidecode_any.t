#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: unidecode_any.t,v 1.1 2006/02/01 23:02:47 eserte Exp $
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

my $x = "\xfc\x{20ac}\N{HORIZONTAL ELLIPSIS}\N{LEFT DOUBLE QUOTATION MARK}";
is(unidecode_any($x, "iso-8859-1"), q{üEU..."});
is(unidecode_any($x, "ascii"), q{uEU..."});

__END__
