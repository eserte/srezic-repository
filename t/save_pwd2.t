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
do "$FindBin::RealBin/../perl/save_pwd2";
# END DO
}

diag "fchdir() available on this system (and will be used)" if _can_fchdir();

{
    my $cwd = _get_pwd();
    {
	my $save_pwd = save_pwd2;
	chdir "/";
    }
    is _get_pwd(), $cwd, 'directory still unchanged';
}

{
    my $cwd = _get_pwd();
    eval {
	my $save_pwd = save_pwd2;
	chdir "/";
	die "Simulate exception";
    };
    like $@, qr{Simulate exception}, 'exception still thrown';
    is _get_pwd(), $cwd, 'directory still unchanged';
}

{
    my $cwd = _get_pwd();
    {
	my $save_pwd_outer = save_pwd2;
	chdir "/";
	my $root_pwd = _get_pwd();
	{
	    my $save_pwd_inner = save_pwd2;
	    chdir $cwd;
	}
	is _get_pwd(), $root_pwd, 'nesting save_pwd2 blocks (inner)';
    }
    is _get_pwd(), $cwd, 'nesting save_pwd2 blocks (outer)';
}

SKIP: {
   skip "Removing directories with an active cwd not possible", 2
	if $^O eq 'MSWin32';

   # load File::Temp late, as it could load more perl deps
   require File::Temp;
   my $tempdir = File::Temp::tempdir("save_pwd2_t_XXXXXXXX", TMPDIR =>1, CLEANUP => 1);

   {
       mkdir "$tempdir/to_be_removed" or die $!;
       {
	   my $save_pwd_outer = save_pwd2; # outer save_pwd2 is for really using the functionality
	   chdir "$tempdir/to_be_removed" or die $!;
	   my @warnings;
	   local $SIG{__WARN__} = sub { push @warnings, @_ };
	   {
	       my $save_pwd_inner = save_pwd2;
	       rmdir "$tempdir/to_be_removed";
	   };
	   if (_can_fchdir()) {
	       is "@warnings", '', 'no warnings if fchdir is used';
	   } else {
	       like "@warnings", qr{Can't chdir back to}, 'expected warning in cleanup'; # exceptions in DESTROY do not seem to cause exceptions
	   }
	   # _get_pwd is probably undefined at this point
       }
   }

   {
       mkdir "$tempdir/to_be_removed_early" or die $!;
       {
	   my $save_pw_outer = save_pwd2; # outer save_pwd2 is for really using the functionality
	   chdir "$tempdir/to_be_removed_early" or die $!;
	   rmdir "$tempdir/to_be_removed_early";
	   my @warnings;
	   local $SIG{__WARN__} = sub { push @warnings, @_ };
	   {
	       my $save_pwd_outer = save_pwd2;
	       # nothing else to do here
	   }
	   if (_can_fchdir()) {
	       is "@warnings", '', 'no warnings if fchdir is used';
	   } else {
	       like "@warnings", qr{No known current working directory}, 'excepted warning';
	   }
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

sub _can_fchdir {
    my $pwd;
    open $pwd, '.' and eval { chdir $pwd; 1 };
}

__END__
