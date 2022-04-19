#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;

# Catch auth token
my $auth_token = '';
$auth_token = CGI::escapeHTML(param('auth_token'));
$auth_token = uri_unescape( $auth_token );

my $student_id = CGI::escapeHTML(param('student_id'));
my $fname = CGI::escapeHTML(param('first_name'));
my $lname = CGI::escapeHTML(param('last_name'));

my $query;
my $sth;
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $db_table_session_id = 'Quaker_Session_ID';
if ( $auth_token ne '' ){
    #check if it matches a session id in the database
    my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
    $query = "SELECT session_id FROM $db_table_session_id";
    $sth = $dbh->prepare($query);
    $sth->execute();
    #if it doesn't match anything, end
    while( my $row = $sth->fetchrow_hashref ){
        # authenticated using auth token
        if( $auth_token eq $row->{session_id}){
			my $dbh2 = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
			#my $query = "SELECT student_id, first_name, last_name FROM $db_table_applications";
			my $q2 = "UPDATE $db_table_applications SET first_name = '$fname', last_name = '$lname' WHERE student_id = $student_id";
			#statement handle object
			my $sth2 = $dbh->prepare($q2);
			$sth2->execute();
			#pass back session id with generated html
			my $file = 'edit_response.html';
			print_auth_html($auth_token, $file);
		}
	}
}
# add auth token to html here programmatically
#my $auth_token = 'theauthtoken';


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
