#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use warnings;
use FindBin;

use Test::More 'no_plan';

# more-or-less just a compilation test

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/unzip";
# END DO
}

chdir "/tmp"; # not really necessary, just in case
my @warnings;
$SIG{__WARN__} = sub { push @warnings, @_ };
eval {
    unzip("$FindBin::RealBin/$FindBin::RealScript");
};
if ($@ =~ qr{Extraction of .* failed}) {
    like "@warnings", qr{format error}, "expected Archive::Zip stack trace";
} else {
    like $@, qr{Can't locate Archive/Zip}, 'expected error if Archive::Zip is not installed';
}

__END__
