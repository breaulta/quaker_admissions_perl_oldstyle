#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;
use Digest::SHA qw(sha256_hex);

# Catch auth token
my $auth_token = CGI::escapeHTML(param('auth_token'));

#Catch data sent from html
my $username = CGI::escapeHTML(param('username'));
my $password = CGI::escapeHTML(param('password'));

# Decode data
$auth_token = uri_unescape( $auth_token );
$username = uri_unescape( $username );
$password = uri_unescape( $password );

# check if anything is empty
my $err = "<p>Username, password are empty! Exiting...</p>";
my $html = qq{$err};
if($username eq '' || $password eq ''){
	print $html;
	die 'empty field';
}

# check if a username already exists
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_auth = 'auth';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
my $query = "SELECT username, salt, password_hash FROM $db_table_auth";
my $sth = $dbh->prepare($query);
$sth->execute();

my $doublesha;
my $salt;
# check if username matches computed hash
while( my $row = $sth->fetchrow_hashref ){
	# double sha to check against database
	$salt = $row->{salt};
	my $concat = $password . $salt;
	$doublesha = sha256_hex($concat);
	if( $username eq $row->{username} && $doublesha eq $row->{password_hash}){
		# generate html
		my $html_file = 'admin.html';
		print "Content-type: text/html\n\n";
		open HTML, "$html_file" or die "I just can't open $html_file";
		while (my $line = <HTML>) {
			print $line;
		}
		exit 0;
	}
}

# add cookie into table
#$dbh->do("INSERT INTO $db_table_auth (username, salt, password_hash) VALUES (?, ?, ?)", undef, $username, $salt, $doublesha);

my $filename = 'auth_log.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "\nusername: $username";
print $fh "\nsalt: $salt";
print $fh "\npassword: $password";
print $fh "\ndouble sha: $doublesha";
close $fh;

# session not properly authenticated
my $html_line = "<p>ACCESS DENIED</p>";
#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;



