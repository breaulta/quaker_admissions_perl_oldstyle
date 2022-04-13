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

my $html_line = "<p>You have successfully updated the application.</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;
