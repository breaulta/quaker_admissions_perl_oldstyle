#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;
use Digest::SHA qw(sha256_hex);


# Catch auth token
my $auth_token = '';
$auth_token = CGI::escapeHTML(param('auth_token'));

#Catch data sent from html
my $username = '';
my $password = '';
$username = CGI::escapeHTML(param('username'));
$password = CGI::escapeHTML(param('password'));

# Decode data
$auth_token = uri_unescape( $auth_token );
$username = uri_unescape( $username );
$password = uri_unescape( $password );

# set admin html file to be generated
my $file = 'admin.html';

# set variables for mySQL connection
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_auth = 'auth';
my $db_table_session_id = 'Quaker_Session_ID';
# check first if auth token matches session id
if ( $auth_token ne '' ){
	#check if it matches a session id in the database
	my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
	my $query = "SELECT session_id FROM $db_table_session_id";
	my $sth = $dbh->prepare($query);
	$sth->execute();
	#if it doesn't match anything, end
	while( my $row = $sth->fetchrow_hashref ){
		if( $auth_token eq $row->{session_id}){
			print_auth_html($auth_token, $file);
		}
	}
	$dbh->disconnect();
	# didn't find a matching id, die
	my $err =	"<p>caught auth token doesn't match any session id!</p>";
	my $html = qq{$err};
	print $html;
	die "caught auth token doesn't match any session id!";
}

my $doublesha;
my $salt;
# check if anything is empty
if($username eq '' || $password eq ''){
	my $err = "<p>Username or password are empty! Exiting...</p>";
	my $html = qq{$err};
	print $html;
	die 'all authorization fields empty!';
}else{
	# check if username/password authenticates
	my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
	my $query = "SELECT username, salt, password_hash FROM $db_table_auth";
	my $sth = $dbh->prepare($query);
	$sth->execute();
	while( my $row = $sth->fetchrow_hashref ){
		# double sha to check against database
		$salt = $row->{salt};
		my $concat = $password . $salt;
		$doublesha = sha256_hex($concat);
		# username/pw combo authenticates successfully
		if( $username eq $row->{username} && $doublesha eq $row->{password_hash}){
			# 'first' authentication, generate auth token, enter in sql, give to user			
			my $generated_token = generate_token();
			# enter into sql
			$dbh->do("INSERT INTO $db_table_session_id (session_id) VALUES (?)", undef, $generated_token);
			#generate html with auth token
			print_auth_html($generated_token, $file);
		}
	}
	$dbh->disconnect();
}

# debugging file
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

sub generate_token{
	my $token;
	my $min = 65;
	my $max = 90;
	my @i = (0..15);
	for(@i){
		$token .= chr($min + int(rand($max-$min)));
	}
	return $token;
}

sub print_auth_html {
    my $auth_t = shift;
    my $html_file = shift;
    # we should be in cgi-bin
    print "Content-type: text/html\n\n";
    open HTML, "$html_file" or die "I just can't open $html_file";
    while (my $line = <HTML>) {
        $line =~ s/(id=\"auth_token\") /$1 name=\"auth_token\" value=\"$auth_t\"/;
        print $line;
    }
	exit 0;
}
