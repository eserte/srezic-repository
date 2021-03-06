#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test::More;
	1;
    }) {
	print "1..0 # skip: no Test::More and/or Capture::Tiny module\n";
	exit;
    }
}

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/fmteach";
# END DO
}

plan 'no_plan';

{
    my %hash = (abc => 1, def => 2, longer => 345, even_longer => 4711, long_val => join("", "a".."z"));
    my @res;
    fmteach {
	my($key,$val,$keyfmt,$valfmt) = @_;
	push @res, sprintf "$keyfmt $valfmt", $key, $val;
    } %hash;
    @res = sort @res;
    is_deeply \@res, [
		      "abc         1                         ",
		      "def         2                         ",
		      "even_longer 4711                      ",
		      "long_val    abcdefghijklmnopqrstuvwxyz",
		      "longer      345                       ",
		     ];
}

{
    my %hash = (abc => 1, def => 2, longer => 345, even_longer => 4711, long_val => join("", "a".."z"));
    my $res;
    fmteach {
	my($key,$val,$keyfmt,$valfmt) = @_;
	$res .= sprintf "$keyfmt $valfmt\n", $key, $val;
    } %hash, sorted => 1;
    is $res, <<EOF; # warn: trailing spaces in the following eof text!
abc         1                         
def         2                         
even_longer 4711                      
long_val    abcdefghijklmnopqrstuvwxyz
longer      345                       
EOF
}

{
    my %hash = (abc => 1, def => 2, longer => 345, even_longer => 4711, long_val => join("", "a".."z"));
    my $res;
    fmteach {
	my($key,$val,$keyfmt,$valfmt) = @_;
	$res .= sprintf "$keyfmt $valfmt\n", $key, $val;
    } %hash, sorted => 1, flags => '';
    is $res, <<EOF;
        abc                          1
        def                          2
even_longer                       4711
   long_val abcdefghijklmnopqrstuvwxyz
     longer                        345
EOF
}

__END__
