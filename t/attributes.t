#!perl -T

use warnings;
use strict;
use Data::Dumper;

use Test::More tests => 6;

BEGIN {
	use_ok( 'HTML::WikiConverter');
	use_ok( 'HTML::WikiConverter::GoogleCode');
}

my $wc = new HTML::WikiConverter( dialect => 'GoogleCode' );

# attribute names for GoogleCode dialect
is(join('; ' , sort(keys(%{$wc->attributes()}))),
	'escape_autolink; summary',
	'google code attributes'
);


$wc = new HTML::WikiConverter( 
		dialect => 'GoogleCode', 	
		escape_autolink => ['JavaScript', 'VbaScript'],
		);

# escape GoogleCode autolinking
is($wc->html2wiki('PerlScript is better than VbaScript, but even with JavaScript'),
	'PerlScript is better than !VbaScript, but even with !JavaScript',
	'escape_autolink'
);

# no escaping autoling under <pre> tags
is($wc->html2wiki('PerlScript is better than <pre>VbaScript</pre>, but even with JavaScript'),
	"PerlScript is better than\n\n{{{\nVbaScript\n}}}\n\n, but even with !JavaScript",
	'escape_autolink'
);

$wc = new HTML::WikiConverter( 
		dialect => 'GoogleCode', 	
		summary => 'The summary message',
		);

# insert summary comment as first line of wiki markup
is($wc->html2wiki('Blah Blah'),
	"# summary The summary message\n\nBlah Blah",
	'summary'
);
