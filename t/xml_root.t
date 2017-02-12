#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: xml_root.t,v 1.1 2006/11/28 20:24:55 eserte Exp $
# Author: Slaven Rezic
#

use strict;
use FindBin;

BEGIN {
    if (!eval q{
	use Test::More;
	use File::Temp;
	use XML::LibXML;
	1;
    }) {
	print "# tests only work with installed Test::More, XML::LibXML and/or File::Temp modules\n";
	print "1..1\n";
	print "ok 1\n";
	exit;
    }
}

# BEGIN DO
do "$FindBin::RealBin/../perl/xml_root";
# END DO

plan tests => 2;

my $xml = <<'EOF';
<simple>
</simple>
EOF

isa_ok(xml_root(\$xml), 'XML::LibXML::Element');
my($fh,$file) = File::Temp::tempfile(UNLINK => 1, SUFFIX => ".xml");
print $fh $xml;
close $fh;
isa_ok(xml_root($file), 'XML::LibXML::Element');

__END__
