#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: Makefile.PL,v 1.1 2004/03/24 21:58:27 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (C) 2004 Slaven Rezic. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: slaven@rezic.de
# WWW:  http://www.rezic.de/eserte/
#

use ExtUtils::MakeMaker;

WriteMakefile
  (
   'NAME'	   => 'srezic-repository',
   'VERSION'       => '0.01',
   'EXE_FILES'     => [],
   'PMLIBDIRS'     => [],
   'PREREQ_PM'     => { },

   'dist' => {'POSTOP'=>'-$(CHMOD) 644 $(DISTVNAME).tar$(SUFFIX)'},

   'ABSTRACT_FROM' => '',
   'AUTHOR'        => 'Slaven Rezic (srezic@cpan.org)',
  );

sub MY::postamble {
    my $postamble = '';

    if (defined $ENV{USER} && $ENV{USER} eq 'eserte' && $^O =~ /bsd/i && -f "../perl.release.mk") {
	$postamble .= <<'EOF';

.include "../perl.release.mk"
.include "../perl.cvs.mk"

EOF
    }

    $postamble;
}

__END__
