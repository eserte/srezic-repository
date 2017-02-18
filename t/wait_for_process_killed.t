#!/usr/bin/perl

use strict;
use FindBin;
use Test::More;
use IO::Pipe ();

BEGIN {
    if (!eval q{ use IPC::Run 'run'; 1 }) {
	plan skip_all => 'No IPC::Run available';
    }
    if ($^O eq 'MSWin32') {
	plan skip_all => 'Does not work on Windows';
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/is_in_path";
do "$FindBin::RealBin/../perl/file_name_is_absolute";
# END DO

plan 'no_plan';

my $sh_repo = "$FindBin::RealBin/../sh";

for my $shell ('sh', 'bash', 'zsh') {
SKIP: {
    skip "$shell is not installed", 1 if !is_in_path($shell);
    my $t0 = time;
    note "Double-fork test child for $shell...";
    my $pipe = IO::Pipe->new;
    if (fork == 0) {
	$pipe->writer;
        $pipe->autoflush(1);
        my $pid = fork;
        if (!defined $pid) {
	    $pipe->print("failed\n");
        } elsif ($pid == 0) {
            local $SIG{INT} = sub { warn "Got signal, wait 3s...\n"; sleep 3; exit 1 };
            sleep 86400;
            die "Never reached!";
	} else {
	    $pipe->print("$pid\n");
	    waitpid $pid, 0;
	}
	exit 0;
    }
    $pipe->reader;
    chomp(my $pid = <$pipe>);
    die "Failed to fork" if $pid eq 'failed';
    note "Forked test child has pid $pid";
    my @cmd = ($shell, '-c', qq{. "$sh_repo/wait_for_process_killed"; wait_for_process_killed -s INT -d -t 6 $pid; exit $?});
    note "Run @cmd...";
    my $success = run [@cmd], '2>', \my $stderr, '>', \my $stdout;
    my $t1 = time;
    ok $success, "Running function in $shell was successful"
	or diag $stderr;
    is $stdout, '';
    like $stderr, qr{\Q$pid};
    like $stderr, qr{\QProcess(es) do(es) not exist anymore};
    ok !kill 0 => $pid;
    cmp_ok $t1-$t0, '>=', 3;
    cmp_ok $t1-$t0, '<=', 4;
}
}
