#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use warnings;
use FindBin;

use Test::More 'no_plan';

use Carp ();

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/in_or_die";
# END DO
}

sub ok_expected (&$) {
    my($code, $testname) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    eval { $code->() };
    if ($@) {
	fail $testname;
	diag "Got unexpected exception: $@";
    } else {
	pass $testname;
    }
}

sub exception_expected (&$$) {
    my($code, $exception_rx, $testname) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    eval { $code->() };
    if (!$@) {
	fail $testname;
    } else {
	pass $testname;
	like $@, qr/$exception_rx/, "$testname (exception check)";
    }
}

ok_expected { in_or_die("foo", qw(foo bar)) } 'contains at front';
ok_expected { in_or_die("bar", qw(foo bar)) } 'contains at end';

ok_expected        { in_or_die({msgprefix => "da value"}, "bar", qw(foo bar)) } 'with msgprefix option';
exception_expected { in_or_die({invopt => "bla"}, "bar", qw(foo bar)) } qr{^\QUnhandled options: invopt bla at}, 'with invalid option';

{
    local *Carp::croak;
    undef &Carp::croak;
    die "Test expects that Carp is not loaded yet or temporily unloaded" if defined &Carp::croak;
    exception_expected { in_or_die("missing", qw(foo bar)) } qr{^\QThe value 'missing' is not in the expected list 'foo', 'bar' at }, 'invalid value detected (without Carp)';
    exception_expected { in_or_die({msgprefix => "da value"}, "missing", qw(foo bar)) } qr{^\Qda value 'missing' is not in the expected list 'foo', 'bar' at }, 'with msgprefix option';
}

exception_expected { in_or_die("missing", qw(foo bar)) } qr{^\QThe value 'missing' is not in the expected list 'foo', 'bar' at \E.*\n.*\Qmain::in_or_die(\E}, 'invalid value detected (with Carp)';
exception_expected { in_or_die({msgprefix => "da value"}, "missing", qw(foo bar)) } qr{^\Qda value 'missing' is not in the expected list 'foo', 'bar' at \E.*\n.*\Qmain::in_or_die(\E}, 'with msgprefix option';

__END__
