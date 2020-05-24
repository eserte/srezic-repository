#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use warnings;
use FindBin;

use Test::More 'no_plan';

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/save_pwd";
# END DO
}

{
    my $cwd = _get_pwd();
    save_pwd {
	chdir "/";
    };
    is _get_pwd(), $cwd, 'directory still unchanged';
}

{
    my $cwd = _get_pwd();
    eval {
	save_pwd {
	    chdir "/";
	    die "Simulate exception";
	};
    };
    like $@, qr{Simulate exception}, 'exception still thrown';
    is _get_pwd(), $cwd, 'directory still unchanged';
}

{
    my $cwd = _get_pwd();
    save_pwd {
	chdir "/";
	my $root_pwd = _get_pwd();
	save_pwd {
	    chdir $cwd;
	};
	is _get_pwd(), $root_pwd, 'nesting save_pwd blocks (inner)';
    };
    is _get_pwd(), $cwd, 'nesting save_pwd blocks (outer)';
}

SKIP: {
    skip "Removing directories with an active cwd not possible", 2
	if $^O eq 'MSWin32';

    # load File::Temp late, as it could load more perl deps
    require File::Temp;
    my $tempdir = File::Temp::tempdir("save_pwd_t_XXXXXXXX", TMPDIR =>1, CLEANUP => 1);

    {
	mkdir "$tempdir/to_be_removed" or die $!;
	save_pwd { # outer save_pwd is for really using the functionality
	    chdir "$tempdir/to_be_removed" or die $!;
	    eval {
		save_pwd {
		    rmdir "$tempdir/to_be_removed";
		};
	    };
	    like $@, qr{Can't chdir back to}, 'expected exception';
	    # _get_pwd is probably undefined at this point
	};
    }

    {
	mkdir "$tempdir/to_be_removed_early" or die $!;
	save_pwd { # outer save_pwd is for really using the functionality
	    chdir "$tempdir/to_be_removed_early" or die $!;
	    rmdir "$tempdir/to_be_removed_early";
	    my @warnings;
	    local $SIG{__WARN__} = sub { push @warnings, @_ };
	    save_pwd {
		# nothing else to do here
	    };
	    like "@warnings", qr{No known current working directory}, 'excepted warning';
	    # _get_pwd is probably undefined at this point
	}
    }
}

# Yes, try to avoid loading another perl module and prefer the system's pwd instead
sub _get_pwd {
    if ($^O =~ m{^(freebsd|linux)$}) {
	chomp(my $pwd = `pwd`);
	$pwd;
    } else {
	require Cwd;
	my $cwd = Cwd::getcwd();
	if ($^O eq 'MSWin32') {
	    # strip possibly existing drive letter (getcwd() is unfortunately inconsistent and may return it or not)
	    $cwd =~ s{^[a-z]:}{}i;
	}
	$cwd;
    }
}

__END__
