package XML::Quote;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(
	xml_quote
	xml_dequote
);
@EXPORT_OK = qw(
	xml_quote
	xml_dequote
);
%EXPORT_TAGS = (
	all	=> [qw(
	xml_quote
	xml_dequote
	)],
);
$VERSION = '1.00';

bootstrap XML::Quote $VERSION;

1;
__END__
=pod

=head1 NAME

XML::Quote - XML quote/dequote functions

=head1 SYNOPSIS

  use XML::Quote;
  
  my $str=q{666 > 444 & "apple" < 'earth'};
  print xml_quote($str),"\n";
  # 666 &gt; 444 &amp; &quot;apple&quot; &lt; &apos;earth&apos;

  my $str2=q{666 &gt; 444 &amp; &quot;apple&quot; &lt; &apos;earth&apos;};
  print xml_quote($str2),"\n";
  # 666 > 444 & "apple" < 'earth'

=head1 DESCRIPTION

This module provides two functions to quote/dequote strings in "xml"-way.

All functions are written in XS and are very fast; they correctly process
utf8, tied, overloaded variables and all the rest of perl "magic".

=head1 FUNCTIONS

=over 4

=item $quoted = xml_quote($str);

This function replaces all occurences of symbols '&', '"', ''', '>', '<'
to '&amp;', '&quot;', '&apos;', '&gt;', '&lt;' respectively.

Returns quoted string or undef if $str is undef.

=item $dequoted = xml_dequote($str);

This function replaces all occurences of '&amp;', '&quot;', '&apos;', '&gt;',
'&lt;' to '&', '"', ''', '>', '<' respectively.
All other entities (for example &nbsp;) will not be touched.

Returns dequoted string or undef if $str is undef.

=back

=head1 EXPORT

xml_quote(), xml_dequote() are exported as default.

=head1 PERFORMANCE

You can use t/benchmark.pl to test the perfomance.  Here is the result
on my P4 box.

  Benchmark: timing 1000000 iterations of perl quote, xs quote...
  perl quote: 90 wallclock secs (81.16 usr +  0.01 sys = 81.17 CPU) @ 12319.82/s (n=1000000)
    xs quote: 17 wallclock secs (14.14 usr +  0.00 sys = 14.14 CPU) @ 70716.36/s (n=1000000)

=head1 AUTHOR

Sergey Skvortsov E<lt>skv@protey.ruE<gt>

=head1 SEE ALSO

L<http://www.w3.org/TR/REC-xml>,
L<perlre>

=head1 COPYRIGHT

Copyright 2003 Sergey Skvortsov E<lt>skv@protey.ruE<gt>.
All rights reserved.

This library is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
