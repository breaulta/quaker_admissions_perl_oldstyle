#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);

my $student_id = CGI::escapeHTML(param('student_id'));
my $fname = CGI::escapeHTML(param('first_name'));
my $lname = CGI::escapeHTML(param('last_name'));

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
#my $query = "SELECT student_id, first_name, last_name FROM $db_table_applications";
my $query = "UPDATE $db_table_applications SET first_name = '$fname', last_name = '$lname' WHERE student_id = $student_id";
#statement handle object
my $sth = $dbh->prepare($query);
$sth->execute();

# add auth token to html here programmatically
my $auth_token = 'theauthtoken';
my $file = 'edit_response.html';

print_auth_html($auth_token, $file);

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
