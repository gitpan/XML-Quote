#!/usr/bin/perl
# $Version: release/perl/base/XML-Quote/t/benchmark.pl,v 1.3 2003/01/24 15:14:55 godegisel Exp $
use strict;
use XML::Quote;
use Benchmark;
use utf8;

use vars qw(@TESTS);

@TESTS=(
'plain text without any special symbols',
q{some symbols & "" ''''><<},
44,
123.11,
'некий "тест >в <\'ютф8 &',
);

timethese(1_000_000,{
'xs quote'	=>	sub {
	my $res;
	for my $t (@TESTS)	{
		$res=xml_quote($t);
	}
},

'perl quote'	=>	sub {
	my $res;
	for my $t (@TESTS)	{
		$res=perl_quote($t);
	}
},

});


sub perl_quote	{
	my $str=shift;

	$str=~s/&/&amp;/g;
	$str=~s/"/&quot;/g;
	$str=~s/'/&apos;/g;
	$str=~s/>/&gt;/g;
	$str=~s/</&lt;/g;

	return $str;
}
__END__
xs quote: 17 wallclock secs (15.48 usr +  0.01 sys = 15.50 CPU) @ 64520.29/s (
n=1000000)
perl quote: 55 wallclock secs (51.23 usr +  0.05 sys = 51.28 CPU) @ 19500.40/s (
n=1000000)

Benchmark: timing 1000000 iterations of perl quote, xs quote...
perl quote: 68 wallclock secs (62.53 usr +  0.06 sys = 62.59 CPU) @ 15975.97/s (
n=1000000)
  xs quote: 17 wallclock secs (15.20 usr +  0.00 sys = 15.20 CPU) @ 65772.17/s (
n=1000000)

Benchmark: timing 1000000 iterations of perl quote, xs quote...
perl quote: 95 wallclock secs (86.12 usr +  0.05 sys = 86.17 CPU) @ 11604.83/s (
n=1000000)
  xs quote: 17 wallclock secs (15.80 usr +  0.00 sys = 15.80 CPU) @ 63303.16/s (
n=1000000)
