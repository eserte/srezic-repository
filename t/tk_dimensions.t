#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test::More;
	use Tk;
	1;
    }) {
	print join("", map { "# $_\n" } split(/\n/, $@));
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/tk_dimensions";
# END DO

my $top = eval { MainWindow->new };
plan skip_all => "Can't create MainWindow: $@" if !$top;

plan tests => 23;

local $TODO = "Failures have to be investigated (different font metrics maybe?)";

$top->geometry("+0+0");
check_dim($top, 200, 200);

$top->geometry("300x100");
$top->idletasks; # force is needed only for toplevels
check_dim($top, 300, 100);

test_widget("Label",
	    29, 18,
	    -text => "Hello",
	    -font => "Helvetica -10",
	    );
test_widget("Entry",
	    128, 20,
	    -width => 20,
	    -font => "Helvetica -10",
	    );
test_widget("Frame",
	    100, 100,
	    -height => 100,
	    -width => 100,
	    );

my $label = $top->Label(-text => "Hello",
			-font => "Helvetica -10")->pack;
check_dim($label, 29, 18);
$label->idletasks; # force geometry changes
check_dim($label, 29, 18);

$label->GeometryRequest(100, 40);
$label->idletasks;
check_dim($label, 100, 40);

$label->destroy;

my $frame = $top->Frame->pack;
$frame->packPropagate(0);
my $entry = $frame->Entry(-font => "Helvetica -10")->pack(-fill => "both");
$frame->GeometryRequest(200,30);
$frame->idletasks;
check_dim($frame, 200, 30);
check_dim($entry, 200, 20);

#MainLoop;

sub test_widget {
    my($type, $expected_width, $expected_height, %args) = @_;

    my $w = $top->$type(%args)->pack;
    ok Tk::Exists($w), "Can create $type widget";
    check_dim($w, $expected_width, $expected_height);
    $w->destroy;
}

sub check_dim {
    my($w, $expected_width, $expected_height) = @_;
    my @dim = $w->dimensions;
    is $dim[0], $expected_width,  "expected $w width";
    is $dim[1], $expected_height, "expected $w height";
}

__END__
