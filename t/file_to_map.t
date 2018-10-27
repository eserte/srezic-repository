#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

use File::Temp ();
use Test::More;

BEGIN {
    plan skip_all => 'Requires perl 5.10 regexp features (named captures)' if $] < 5.010;
}

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/file_to_map";
# END DO
}

plan 'no_plan';

{
    my $tmp = File::Temp->new;
    $tmp->print(<<EOF);
tarzan-01 DE something else
tarzan-02 IT something else
tarzan-03 UK something else
EOF
    $tmp->close;

    my $expected = {
	'tarzan-01' => 'DE',
	'tarzan-02' => 'IT',
	'tarzan-03' => 'UK',
    };
    my $qr = qr{^(?<k>\S+)\s+(?<v>\S+)};

    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, @_ };

    my $map1 = file_to_map("$tmp", $qr);
    is_deeply $map1, $expected;

    if (-x "/bin/cat") {
	my $map2 = file_to_map("/bin/cat $tmp | ", $qr);
	is_deeply $map2, $expected;
    }

    is_deeply \@warnings, [];

    my $map3 = file_to_map("$tmp", qr{^does not match(?<k>\S+)\s+(?<v>\S+)});
    is_deeply $map3, {};
    like $warnings[0], qr{^Line <tarzan-01 DE something else> does not match.*warn only once};
    like $warnings[1], qr{^Total warnings: 3 at };
    is scalar(@warnings), 2;
}


__END__
