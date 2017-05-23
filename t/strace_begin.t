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
	use File::Temp;
	1;
    }) {
	print "1..0 # skip: no Test::More and/or File::Temp modules\n";
	exit;
    }
}

do "$FindBin::RealBin/../perl/is_in_path";
do "$FindBin::RealBin/../perl/file_name_is_absolute";

if (!is_in_path('strace')) {
    plan skip_all => 'No strace available on this system';
}

# BEGIN, so prototypes work
BEGIN {
    do "$FindBin::RealBin/../perl/strace_begin";
}

plan 'no_plan';

require Time::HiRes;

{
    my $tmp = File::Temp->new;
    my $res = strace {
	for (1..2) {
	    Time::HiRes::sleep(0.1);
	}
	"scalar result";
    } '-o', "$tmp", '-f';
    ok $res, 'scalar result';
    $tmp->seek(0,0);
    local $/ = undef;
    my $tmp_contents = <$tmp>;
    like $tmp_contents, qr{nanosleep}, 'found sleep() call in strace log';
    like $tmp_contents, qr{kill}, 'found self-kill in strace log';
    like $tmp_contents, qr{^$$\s+}, 'found my pid in strace log';
}

{
    my $tmp = File::Temp->new;
    {
	my $strace_keeper = strace_begin(qw(-tt -T -f --strace-cmd), ['strace'], '-o', "$tmp");
	for (1..2) {
	    Time::HiRes::sleep(0.1);
	}
    }
    $tmp->seek(0,0);
    local $/ = undef;
    my $tmp_contents = <$tmp>;
    like $tmp_contents, qr{nanosleep}, 'found sleep() call in strace log';
    like $tmp_contents, qr{kill}, 'found self-kill in strace log';
    like $tmp_contents, qr{^$$\s+}, 'found my pid in strace log';
}

__END__
