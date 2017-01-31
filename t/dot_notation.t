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
	print "1..0 # skip: no Test::More module\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/dot_notation";
# END DO

plan 'no_plan';

{
    my $deep = { foo => { bar => { baz => 4711 } } };

    ok  exists_by_dot_notation($deep, 'foo');
    ok  exists_by_dot_notation($deep, 'foo.bar');
    ok  exists_by_dot_notation($deep, 'foo.bar.baz');
    ok !exists_by_dot_notation($deep, 'foo.bar.baz.no');

    is_deeply get_by_dot_notation($deep, 'foo'), { bar => { baz => 4711 } };
    is_deeply get_by_dot_notation($deep, 'foo.bar'), { baz => 4711 };
    is        get_by_dot_notation($deep, 'foo.bar.baz'), 4711;
    is        get_by_dot_notation($deep, 'foo.bar.baz.no'), undef;
}

{
    my %flat = (abc => 1, def => 2);

    ok  exists_by_dot_notation(\%flat, 'abc');
    ok !exists_by_dot_notation(\%flat, 'xyz');

    is get_by_dot_notation(\%flat, 'abc'), 1;
    is get_by_dot_notation(\%flat, 'xyz'), undef;
}

{
    my $deep = { foo => { bar => { baz => 4711 } } };
    is set_by_dot_notation($deep, 'foo.bar.baz', 3.14), 3.14;
    is $deep->{foo}->{bar}->{baz}, 3.14;
    is set_by_dot_notation($deep, 'foo.bar.baz.no', "bla"), "bla";
    is $deep->{foo}->{bar}->{baz}->{no}, "bla";
    is set_by_dot_notation($deep, 'foo.auto.vivi.fication', "foo"), "foo";
    is $deep->{foo}->{auto}->{vivi}->{fication}, "foo";
}

{
    my $deep = { foo => { bar => { baz => 4711 } } };

    eval { exists_by_dot_notation($deep, 'foo.') };
    like $@, qr{^FATAL ERROR};
    eval { get_by_dot_notation($deep, 'foo.') };
    like $@, qr{^FATAL ERROR};
}

__END__
