#!/usr/bin/perl

# scrapes openbible.info for topics and makes flash cards
# designed to work with the free flashcard reader "jmemorize"
# author:  james@rubysash.com
# 4/21/2018

# 1. Run the script with your search phrase:  perl verses.pl fear
# 2. Open jmemoroize and import it as CSV
# 3. Use jmemorize to learn
# 4. Edit/update the cards if you like, because they test verse number against verse, and you may want topic or questions to match a verse.  Regardless this program helps you make flashcards.


# final updates might be to use a CSV module and a gui/Tk
# then par compile it and distribute
use strict;
use warnings;
use 5.010;
 
use HTTP::Tiny;
use Data::Dumper qw(Dumper);
use HTML::TokeParser;

# this website graciously allows access to it's database
# of topical searches 
my $url = 'https://www.openbible.info/topics/';

# build search url from CLI input
my @search = @ARGV;

# error if nothing was entered
if (@search) {} else {die "error: " . __LINE__ . "\nusage:  perl " . $0 . " will of god\nThen you open the csv file for use with jmemorize flash cards\n";}

# continue building search
my $search = join("_",@search);
my $url2 = $url . $search;

# clean up our filename, don't allow anything except
my $search2 = $search;
   $search2 =~ s/[^\w\_]{1}//ig; 
my $filename = $search2 . '.csv';

my %verses;   # need a hash to make it pretty

my $counter  = 0; # group into clumps of 10 for easier mastery, tracks the 10th loop
my $counter2 = 0; # builds the category name
my $allcount = 0; # tracks all flashcards made
 
my $response = HTTP::Tiny->new->get($url2);

if ($response->{success}) {
	
	# tell them what's going on, even though this only takes a second
	print qq~UPDATING: $filename\n~;

	# if you want to see header content info
	#while (my ($name, $v) = each %{$response->{headers}}) {
	#    for my $value (ref $v eq 'ARRAY' ? @$v : $v) {
	#        say "$name: $value";
	#    }
	#}
	
	# just tell us the length
	#if (length $response->{content}) {
	#    say 'Length: ', length $response->{content};
	#}
	#print "\n";

	# you could do this from a __DATA__ handle, form, etc
	my $parser = HTML::TokeParser->new(\$response->{content});
	while ( my $token = $parser->get_token ) {
		my ($verse, $p, $h3);
		if ( $token->[0] eq 'S' ) {
			if ( $token->[1] eq 'h3') {
				$h3 =  $parser->get_text('/h3');
				$h3 =~ s/[^\w\-\: ]/ /g; # only these characters, dump the rest
				$h3 =~ s/\s+/ /g;
				$h3 =~ s/^\s+//; # trim first space, if exists
				$h3 =~ s/\s+$//; # trim last space, if exists
				if ($h3 =~ m/(.*) ESV/) { 
					$verse = $1;
					$verses{$verse} = $verse; }

				$p = $parser->get_text('/p');
				$p =~ s/[^\w\,\-\.\!\;\?\:\' ]/ /g; # only these characters, dump the rest
				$p =~ s/\s+/ /g;
				$p =~ s/^\s+//; # trim first space, if exists
				$p =~ s/\s+$//; # trim last space, if exists
  
				{
					no warnings;
					$verses{$verse} = $p;
				}
			}
		}
	}

	if (-e $filename) {
		die "error: " . __LINE__ . "\n$filename already exists, not appending/duplicating\n"; 
	} else {

		open (my $fh, '>>', $filename) or die "Failed to Open FH: '$filename' $!\n";

		# print the header that jmemorize needs
		print $fh qq~Frontside,Flipside,Category,Level\n~;

		foreach my $verse (sort keys %verses) {
			my $category = $search.$counter2;
			
			# aint got no time for dat kind o long memorization!
			# just get the smaller, easier ones to memorize
			# skip the blanks, if they exist too
			if (length ($verses{$verse}) > 300) { 
				next; 
			} elsif ($verse eq '') {
				next;
			} else {
			
				# it's probably what we want, accept and print, update counters
				print $fh qq~"$verse","$verses{$verse}","$category",0\n~;
				$counter++;
				$allcount++;
			}

			# I don't want 300 verses in 1 category, make my learning easier
			if ($counter > 9) {$counter2++; $counter = 0;}
		}

		close $fh;
		print "FOUND: $allcount records\n";
	}
} else {
	say "Failed: $response->{status} $response->{reasons}";
}







__DATA__
Samples of how to create the CSV files.....

C:\Users\James\Desktop\icons>perl verses.pl judging
UPDATING: judging.csv
Length: 47072

UPDATED: 36 records

C:\Users\James\Desktop\icons>perl verses.pl wealth
UPDATING: wealth.csv
Length: 93702

UPDATED: 71 records

C:\Users\James\Desktop\icons>perl verses.pl work ethic
UPDATING: work_ethic.csv
Length: 83778

UPDATED: 84 records

C:\Users\James\Desktop\icons>perl verses.pl honesty
UPDATING: honesty.csv
Length: 82997

UPDATED: 85 records

C:\Users\James\Desktop\icons>perl verses.pl selfishness
UPDATING: selfishness.csv
Length: 90904

UPDATED: 75 records

C:\Users\James\Desktop\icons>perl verses.pl pure heart
UPDATING: pure_heart.csv
Length: 60056

UPDATED: 47 records
