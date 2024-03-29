#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use warnings;
use FindBin;

BEGIN {
# BEGIN DO
do "$FindBin::RealBin/../perl/get_accesslog_parser";
# END DO

# testing helpers
do "$FindBin::RealBin/../perl/module_exists";
do "$FindBin::RealBin/../perl/module_path";
}

use Test::More;

if (   !module_exists('Time::Moment')
    && !module_exists('DateTime::Format::ISO8601')
    && !do {
	my $mod_path = module_path('Time::Piece');
	if ($mod_path && open my $fh, $mod_path) {
	    my $Time_Piece_VERSION;
	    while(<$fh>) {
		if (/\$VERSION\s*=\s*'?([\d\.]+)/) {
		    $Time_Piece_VERSION = $1;
		    last;
		}
	    }
	    $Time_Piece_VERSION >= 1.16;
	} else {
	    0;
	}
    }
) {
    plan skip_all => 'No module available for date/time parsing';
}
plan 'no_plan';

{
    my $logline = qq{127.0.0.1 - - [14/Feb/2023:01:02:03 +0100] "GET /health HTTP/1.0" 200 2 "-" "-" 0.000583 pid=29053 reqno=852 mem=213.02 memdelta=0.00\n};

    {
	my $p = get_accesslog_parser;
	my $fields = $p->($logline);
	is_deeply $fields, {
	    "XXX1" => "-",
	    "XXX2" => "-",
	    "content_length" => 2,
	    "date" => "2023-02-14",
	    "date_d" => 14,
	    "date_mon" => "Feb",
	    "date_y" => 2023,
	    "duration" => "0.000583",
	    "epoch" => 1676332923,
	    "ips" => "127.0.0.1",
	    "iso8601" => '2023-02-14T01:02:03+01:00',
	    "method" => "GET",
	    "path" => "/health",
	    "proto" => "HTTP/1.0",
	    "referer" => "-",
	    "status" => 200,
	    "time" => "01:02:03",
	    "time_h" => "01",
	    "time_m" => "02",
	    "time_s" => "03",
	    "tzoffset" => "+0100",
	    "ua" => "-",
	    "vhost0" => undef,
	}, 'parser result with all fields';
    }

    {
	my $p = get_accesslog_parser(fields => [qw(epoch path)]);
	my $fields = $p->($logline);
	is_deeply $fields, {
	    "epoch" => 1676332923,
	    "path" => "/health",
	}, 'parser result with some fields';
    }

    {
	my $p = get_accesslog_parser(fields => [qw(path logline)]);
	my $fields = $p->($logline);
	is_deeply $fields, {
	    "path" => "/health",
	    "logline" => do { my $logline_without_newline = $logline; $logline_without_newline =~ s/\n\z//; $logline_without_newline },
	}, 'parser result including logline field';
    }

    {
	my $p = get_accesslog_parser(fields => ['duration']);
	(my $logline_with_alternative_duration = $logline) =~ s{0\.000583}{583us};
	my $fields = $p->($logline_with_alternative_duration);
	is_deeply $fields, {
	    duration => "0.000583",
	}, 'alternative duration parsing';
    }

    {
	my $p = get_accesslog_parser(fields => ['iso8601', 'epoch']);
	(my $logline_with_another_tz = $logline) =~ s{\+0100}{+0000};
	my $fields = $p->($logline_with_another_tz);
	is_deeply $fields, {
	    iso8601 => '2023-02-14T01:02:03+00:00',
	    epoch => 1676336523,
	}, 'another time zone';
    }

    our @GET_PARSER_ACCESSLOG_PREFERRED_DATETIME_PARSERS;
    my @test_datetime_parsers = @GET_PARSER_ACCESSLOG_PREFERRED_DATETIME_PARSERS; shift @test_datetime_parsers;
    for my $preferred_parser (@test_datetime_parsers) {
	local @GET_PARSER_ACCESSLOG_PREFERRED_DATETIME_PARSERS = ($preferred_parser, @GET_PARSER_ACCESSLOG_PREFERRED_DATETIME_PARSERS);
	my $p = get_accesslog_parser(fields => ['epoch']);
	my $fields = $p->($logline);
	is_deeply $fields, {
	    epoch => 1676332923,
	}, "date/time parser on front of search list: $preferred_parser";
    }
}

ok !eval { get_accesslog_parser(invalid => "option") }, 'error with invalid option';
like $@, qr{Unhandled options: invalid option};

ok !eval { get_accesslog_parser(fields => ['invalid_field']) }, 'error with invalid field';
like $@, qr{Invalid fields: invalid_field};
like $@, qr{Valid fields are: };

{
    my $p = get_accesslog_parser;
    my $fields = $p->("invalid accesslog line");
    is_deeply $fields, {
	error => "cannot parse logline",
    }, 'parser result with invalid accesslog line';
}

{
    my $p = get_accesslog_parser(fields => ['logline']);
    my $fields = $p->("invalid accesslog line");
    is_deeply $fields, {
	error => "cannot parse logline",
	logline => "invalid accesslog line",
    }, 'parser result with invalid accesslog line';
}

__END__
