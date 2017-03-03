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
	use File::Temp qw(tempfile);
	use Getopt::Long;
	1;
    }) {
	print "1..0 # skip: no Test::More, Getopt::Long and/or File::Temp modules\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/simple_rcfile_reader";
# END DO

plan 'no_plan';

{
    my($tmpfh,$tmpfile) = tempfile(UNLINK => 1);
    print $tmpfh <<EOF;
--option-a A
--option-b=B
-option-c C
# --option-d is ignored
# following an empty line

--option-d D --option-e E
--option-f 'foo "bar" bla'
--option-g "foo 'bar' bla"
EOF
    close $tmpfh;

    my @opt_spec = qw(option-a=s option-b=s option-c=s option-d=s option-e=s option-f=s option-g=s option-cmdline);

    {
	local @ARGV = ('--option-cmdline');
	simple_rcfile_reader($tmpfile, quiet => 1);
	my %opt;
	eval { GetOptions(\%opt, @opt_spec) };
	is $@, '', 'GetOptions does not fail';
	is $opt{'option-a'}, 'A';
	is $opt{'option-b'}, 'B';
	is $opt{'option-c'}, 'C';
	is $opt{'option-d'}, 'D';
	is $opt{'option-e'}, 'E';
	is $opt{'option-f'}, q{foo "bar" bla};
	is $opt{'option-g'}, q{foo 'bar' bla};
	is $opt{'option-cmdline'}, 1;
    }

    {
	local @ARGV = ('--option-cmdline', '--skiprcfile');
	simple_rcfile_reader($tmpfile, quiet => 1);
	my %opt;
	eval { GetOptions(\%opt, @opt_spec) };
	is $@, '', 'GetOptions does not fail';
	ok !exists $opt{'option-a'}, '--skiprcfile works';
	is $opt{'option-cmdline'}, 1;
    }
}

__END__
