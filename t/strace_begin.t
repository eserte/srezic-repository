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
if ($^O eq 'MSWin32') {
    plan skip_all => "Fails on Windows systems";
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
	_wait_for_strace_started("$tmp");
	Time::HiRes::sleep(0.3);
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
	_wait_for_strace_started("$tmp");
	Time::HiRes::sleep(0.3);
    }
    $tmp->seek(0,0);
    local $/ = undef;
    my $tmp_contents = <$tmp>;
    like $tmp_contents, qr{nanosleep}, 'found sleep() call in strace log';
    like $tmp_contents, qr{kill}, 'found self-kill in strace log';
    like $tmp_contents, qr{^$$\s+}, 'found my pid in strace log';
}

sub _wait_for_strace_started {
    my($logfile) = @_;
    # simple check to make sure strace started (-s will trigger a
    # syscall, so $tmp is not empty anymore)
    for (1..100) {
	last if -s "$logfile";
	Time::HiRes::sleep(0.05);
    }
}

__END__
