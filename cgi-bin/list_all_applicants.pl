#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
my $query = "SELECT student_id, first_name, last_name FROM $db_table_applications";
#statement handle object
my $sth = $dbh->prepare($query);
$sth->execute();
#array of 2 deep arrays
my @student_apps;
while( my $row = $sth->fetchrow_hashref ){
	push(@student_apps, [ $row->{student_id}, $row->{first_name}, $row->{last_name} ]);
}
my $appslist_html = "<p>first name | last name</p>";
foreach my $app_row (@student_apps){
	#$appslist_html .= "<br><p>@$app_row[0] | @$app_row[1]</p>";
	$appslist_html .= "<p>@$app_row[1] | @$app_row[2] ";
	$appslist_html .= "<button type='button' id='edit_@$app_row[0]' onclick='edit_applicant(@$app_row[0])'>Edit</button></p>";
}
#my $html_line = "<p> this is a line of html programmically inserted </p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$appslist_html
};

print $html_template;
