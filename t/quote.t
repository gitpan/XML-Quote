#!/usr/bin/perl
# $Version: release/perl/base/XML-Quote/t/quote.t,v 1.4 2003/01/25 13:17:41 godegisel Exp $
package TEST_OVERLOAD;
use overload '""' => sub {${$_[0]} ? 'true' : 'false'};

sub new	{
	bless \$_[1], $_[0];
}

package TEST_TIED;

sub TIESCALAR	{
	my $val=$_[1];
	bless \$val, $_[0];
}

sub FETCH {
	uc(${$_[0]});
}

sub STORE {
	${$_[0]}=$_[1];
}

package main;
use strict;
use utf8;

use Test::More tests => 48;

BEGIN {use_ok('XML::Quote')};

my @tests=(
[
"amp",
"amp",
],

[
"&",
"&amp;",
],

[
qq{&"'><},
"&amp;&quot;&apos;&gt;&lt;",
],

[
"&amp;",
"&amp;amp;",
],

[
"\0",
"\0",
],

[
'plain text without any special symbols',
'plain text without any special symbols',
],

[
44,
44,
],

[
123.11,
123.11,
],

[
'некий "тест >в <\'ютф8 &',
q{некий &quot;тест &gt;в &lt;&apos;ютф8 &amp;},
],
);

my ($to_quote, $expected, $quoted, $dequoted);
for my $arr (@tests)	{
	my ($to_quote, $expected)=@$arr;
	my $quoted=XML::Quote::xml_quote($to_quote);
	is($quoted, $expected, ':'.$to_quote);
	my $dequoted=XML::Quote::xml_dequote($quoted);
	is($dequoted, $to_quote, ':'.$expected);
}#for

my @tests_min=(
[
"amp",
"amp",
],

[
"&",
"&amp;",
],

[
qq{&"'><},
"&amp;&quot;'>&lt;",
],

[
"\0",
"\0",
],

[
'plain text without any special symbols',
'plain text without any special symbols',
],

[
44,
44,
],

[
123.11,
123.11,
],

[
'некий "тест >в <\'ютф8 &',
q{некий &quot;тест >в &lt;'ютф8 &amp;},
],
);


for my $arr (@tests_min)	{
	my ($to_quote, $expected)=@$arr;
	my $quoted=XML::Quote::xml_quote_min($to_quote);
	is($quoted, $expected, ':'.$to_quote);
	my $dequoted=XML::Quote::xml_dequote($quoted);
	is($dequoted, $to_quote, ':'.$expected);
}#for

my @tests_overload=(
[
TEST_OVERLOAD->new(1),
'true',
],

[
TEST_OVERLOAD->new(0),
'false',
],
);
for my $arr (@tests_overload)	{
	my ($to_quote, $expected)=@$arr;
	my $quoted=XML::Quote::xml_quote($to_quote);
	is($quoted, $expected, ':'.$to_quote);
	my $dequoted=XML::Quote::xml_dequote($quoted);
	is($dequoted, "$to_quote", ':'.$expected);
}#for

tie(my $tied_scalar,'TEST_TIED');
$tied_scalar='test&rest';
my @tests_tied=(
[
$tied_scalar,
'TEST&amp;REST',
],
);

use Devel::Peek;
for my $arr (@tests_tied)	{
	my ($to_quote, $expected)=@$arr;
	my $quoted=XML::Quote::xml_quote($to_quote);
	is($quoted, $expected, ':'.$to_quote);
	my $dequoted=XML::Quote::xml_dequote($quoted);
	is($dequoted, "$to_quote", ':'.$expected);
}#for

my @tests2=(
['&amp;','&'],
['&quot;','"'],
['&apos;','\''],
['&gt;&lt;','><'],
['&160','&160'],
['&;','&;'],
['&','&'],
);

#use Devel::Peek;
for my $arr (@tests2)	{
	my ($bef,$aft)=@$arr;
#	Dump($bef);
	my $cvt=XML::Quote::xml_dequote($bef);
#	Dump($aft);
#	Dump($cvt);
	is($cvt, $aft, ':'.$bef);
}#for

