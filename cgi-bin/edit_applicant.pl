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
#my $fname = CGI::escapeHTML(param('first_name'));
#my $lname = CGI::escapeHTML(param('last_name'));

my $query;
my $sth;
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $db_table_session_id = 'Quaker_Session_ID';
# did we catch an auth token?
if ( $auth_token ne '' ){
    #check if it matches a session id in the database
    my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
    $query = "SELECT session_id FROM $db_table_session_id";
    $sth = $dbh->prepare($query);
    $sth->execute();
    while( my $row = $sth->fetchrow_hashref ){
        # we've now authenticated using auth token
        if( $auth_token eq $row->{session_id}){
			# might not need this:
			#my $dbh2 = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
			my $q2 = "SELECT * FROM $db_table_applications, WHERE student_id='$student_id'";
			#statement handle object
			$sth = $dbh->prepare($q2);
			#my $sth2 = $dbh->prepare($q2);
			#$sth2->execute();
			$sth->execute();
			# presumably, each key and value is now stored in %row
			while( my %row = $sth->fetchrow_hashref){
				# foreach my $key in %row
				# match key to html row
				# append value='$row{$key}' so the value will show up in the generated html
				



			}

			my $file = 'edit_response.html';
			print_auth_html($auth_token, $file);
		}
	}
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
