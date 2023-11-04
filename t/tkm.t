#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;
use Getopt::Long;
use Test::More;

# BEGIN DO
do "$FindBin::RealBin/../perl/tkm";
# END DO

plan skip_all => "No DISPLAY" if !$ENV{DISPLAY};
plan skip_all => "No tkmessage available" if !is_in_path('tkmessage');

GetOptions("doit" => \my $doit)
    or die "usage?";

$doit
    or plan skip_all => "Please run with --doit";

tkm('true');
tkm('false');
tkm({fork=>0}, 'echo', 'This should block until the dialog is confirmed.');

# REPO BEGIN
# REPO NAME is_in_path /home/e/eserte/src/srezic-repository 
# REPO MD5 4be1e368fea0fa9af4e89256a9878820

=head2 is_in_path($prog)

=for category File

Return the pathname of $prog, if the program is in the PATH, or undef
otherwise.

=cut

sub is_in_path {
    my($prog) = @_;
    require File::Spec;
    if (File::Spec->file_name_is_absolute($prog)) {
	if ($^O eq 'MSWin32') {
	    return $prog       if (-f $prog && -x $prog);
	    return "$prog.bat" if (-f "$prog.bat" && -x "$prog.bat");
	    return "$prog.com" if (-f "$prog.com" && -x "$prog.com");
	    return "$prog.exe" if (-f "$prog.exe" && -x "$prog.exe");
	    return "$prog.cmd" if (-f "$prog.cmd" && -x "$prog.cmd");
	} else {
	    return $prog if -f $prog and -x $prog;
	}
    }
    require Config;
    %Config::Config = %Config::Config if 0; # cease -w
    my $sep = $Config::Config{'path_sep'} || ':';
    foreach (split(/$sep/o, $ENV{PATH})) {
	if ($^O eq 'MSWin32') {
	    # maybe use $ENV{PATHEXT} like maybe_command in ExtUtils/MM_Win32.pm?
	    return "$_\\$prog"     if (-f "$_\\$prog" && -x "$_\\$prog");
	    return "$_\\$prog.bat" if (-f "$_\\$prog.bat" && -x "$_\\$prog.bat");
	    return "$_\\$prog.com" if (-f "$_\\$prog.com" && -x "$_\\$prog.com");
	    return "$_\\$prog.exe" if (-f "$_\\$prog.exe" && -x "$_\\$prog.exe");
	    return "$_\\$prog.cmd" if (-f "$_\\$prog.cmd" && -x "$_\\$prog.cmd");
	} else {
	    return "$_/$prog" if (-x "$_/$prog" && !-d "$_/$prog");
	}
    }
    undef;
}
# REPO END

__END__
