#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;
use Digest::SHA qw(sha256_hex);

#Catch data sent from html
my $username = CGI::escapeHTML(param('username'));
my $salt = CGI::escapeHTML(param('salt'));
my $password = CGI::escapeHTML(param('password'));

# Decode data
$username = uri_unescape( $username );
$salt = uri_unescape( $salt );
$password = uri_unescape( $password );

my $err = "<p>Username, salt, or password are empty! Exiting...</p>";
my $html = qq{$err};
# check if anything is empty
if($username eq '' || $salt eq '' || $password eq ''){
	print $html;
	exit 0;
}

# check if a username already exists
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_auth = 'auth';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
my $query = "SELECT username FROM $db_table_auth";
my $sth = $dbh->prepare($query);
$sth->execute();

# Ensure unique username
$err = "<p>Username is already taken! Pick another please</p>";
$html = qq{$err};
while( my $row = $sth->fetchrow_hashref ){
	if( $username eq $row->{username} ){
		print $html;
		exit 0;
	}
}

my $concat = $password . $salt;
my $doublesha = sha256_hex($concat);

# enter valid data into table
# add cookie in a sec
$dbh->do("INSERT INTO $db_table_auth (username, salt, password_hash) VALUES (?, ?, ?)", undef, $username, $salt, $doublesha);

my $filename = 'auth_log.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "\nusername: $username";
print $fh "\nsalt: $salt";
print $fh "\npassword: $password";
print $fh "\ndouble sha: $doublesha";
close $fh;

my $html_line = "<p>You have successfully added a new admin account.</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;



