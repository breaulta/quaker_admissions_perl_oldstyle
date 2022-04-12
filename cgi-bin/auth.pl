#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;
use Digest::SHA qw(sha256_hex);

my $username = CGI::escapeHTML(param('username'));
my $salt = CGI::escapeHTML(param('salt'));
my $password = CGI::escapeHTML(param('password'));

$username = uri_unescape( $username );
$salt = uri_unescape( $salt );
$password = uri_unescape( $password );

my $concat = $password . $salt;
my $doublesha = sha256_hex($concat);

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table = 'admiss';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);

#$dbh->do("INSERT INTO $db_table (first_name, last_name) VALUES (?, ?)", undef, $fname, $lname);


my $filename = 'auth_log.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "\nusername: $username";
print $fh "\nsalt: $salt";
print $fh "\npassword: $password";
print $fh "\ndouble sha: $doublesha";
close $fh;

#my $q = new CGI;

my $html_line = "<p>You have successfully applied.</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;



