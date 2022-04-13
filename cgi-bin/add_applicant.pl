#!/usr/bin/perl
use strict;
use warnings;

use CGI qw(:standard escapeHTML);
use DBI;

my $fname = CGI::escapeHTML(param('first_name'));
my $lname = CGI::escapeHTML(param('last_name'));

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("INSERT INTO $db_table_applications (first_name, last_name) VALUES (?, ?)", undef, $fname, $lname);


my $filename = 'output.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "First name: $fname";
print $fh "Last name: $lname";
close $fh;

my $q = new CGI;

my $html_line = "<p>You have successfully applied.</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;
