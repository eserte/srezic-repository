#!/usr/bin/perl -w
# -*- cperl -*-

#
# Author: Slaven Rezic
#

use strict;
use FindBin;

use Test::More;

plan skip_all => 'Insufficient dependencies (Text::Diff)'
    if !module_exists('Text::Diff');
plan skip_all => 'Insufficient dependencies (Data::Dumper)'
    if !module_exists('Data::Dumper');

plan 'no_plan';

# BEGIN DO
do "$FindBin::RealBin/../perl/data_diff";
# END DO
ok defined &data_diff, 'subroutine loaded and compiled OK'
    or diag $@;

{
    eval { data_diff("", "", {invalid=>"option"}) };
    like $@, qr{^unhandled options: invalid option}, 'invalid option';
}

{
    my $old = "abc\ndef\n";
    my $new = "abc\ndef\n";
    is data_diff($old, $new), '', 'same strings';
}

{
    my $old = [1..3];
    my $new = [1..3];
    is data_diff($old, $new), '', 'same arrays';
}

{
    my $old = {a=>1, b=>2};
    my $new = {a=>1, b=>2};
    is data_diff($old, $new), '', 'same hashes';
}

{
    my $old = [1..2];
    my $new = [1];
    is data_diff($old, $new), <<'EOF', 'different arrays, with default Table style';
+----+------+----+-----+
| Elt|Old   | Elt|New  |
+----+------+----+-----+
|   0|[     |   0|[    |
*   1|  1,  *   1|  1  *
*   2|  2   *    |     |
|   3|]     |   2|]    |
+----+------+----+-----+
EOF
}

{
    my $old = {a=>1, b=>2};
    my $new = {a=>1};
    is data_diff($old, $new, { diff_style => 'Unified' }), <<'EOF', 'different hashes, with Unified style';
--- Old
+++ New
@@ -1,4 +1,3 @@
 {
-  a => 1,
-  b => 2
+  a => 1
 }
EOF
}

{
    my $old = "abc\n";
    my $new = "abc\ndef\n";
    is data_diff($old, $new, { filename_a => "Alt", filename_b => "Neu" }), <<'EOF', 'different strings, changing filenames';
+---+------+---+------+
| Ln|Alt   | Ln|Neu   |
+---+------+---+------+
|  1|'abc  |  1|'abc  |
|   |      *  2|def   *
|  2|'     |  3|'     |
+---+------+---+------+
EOF
}

# REPO BEGIN
# REPO NAME module_exists /home/slaven.rezic/src/srezic-repository 
# REPO MD5 1ea9ee163b35d379d89136c18389b022

#=head2 module_exists($module)
#
#Return true if the module exists in @INC or if it is already loaded.
#
#=cut

sub module_exists {
    my($filename) = @_;
    $filename =~ s{::}{/}g;
    $filename .= ".pm";
    return 1 if $INC{$filename};
    foreach my $prefix (@INC) {
	my $realfilename = "$prefix/$filename";
	if (-r $realfilename) {
	    return 1;
	}
    }
    return 0;
}
# REPO END

__END__
