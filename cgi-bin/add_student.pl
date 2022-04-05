#!/usr/bin/perl
use strict;
use warnings;

use CGI;

my $q = CGI->new();
my $fname;
my $lname;

if ( $q->param()) { 
    #my $name_value = $q->param( 'name' );
	$fname = $q->param( 'first_name' );
	$lname = $q->param( 'last_name' );
}

my $filename = 'output.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "First name: $fname";
print $fh "Last name: $lname";
close $fh;


