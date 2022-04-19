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
			# found active session id, dc from first query
			#$dbh->disconnect();
			my $dbh2 = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
			my $q2 = "SELECT student_id, first_name, last_name FROM $db_table_applications";
			#statement handle object
			my $sth2 = $dbh2->prepare($q2);
			$sth2->execute();
			#array of 2 deep arrays
			my @student_apps;
			while( my $row = $sth2->fetchrow_hashref ){
				push(@student_apps, [ $row->{student_id}, $row->{first_name}, $row->{last_name} ]);
			}
			my $appslist_html = "<p>first name | last name</p>";
			foreach my $app_row (@student_apps){
				#$appslist_html .= "<br><p>@$app_row[0] | @$app_row[1]</p>";
				$appslist_html .= "<p>@$app_row[1] | @$app_row[2] ";
				$appslist_html .= "<button type='button' id='edit_@$app_row[0]' onclick='edit_applicant(@$app_row[0])'>Edit</button></p>";
			}
			print "Content-type: text/html\n\n";
			print qq{
<!DOCTYPE HTML>
<html>
<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
<meta content="utf-8" http-equiv="encoding">
<body>
    <form action='/cgi-bin/edit_applicant.pl' method='post'>
        <input type="hidden" style="display: none;" id="auth_token" value="$auth_token" name="auth_token">
        <input type='text' id='student_id' name='student_id' style=''>
        <label for='first_name'>First Name:</label>
        <input type='text' id='first_name' name='first_name'>
    <br>
        <label for='last_name'>Last Name:</label>
        <input type='text' id='last_name' name='last_name'>
    <br><br>
        <input type='submit' value='Save'>
    </form>

			};
			print $appslist_html;
			print qq{

<script>
function edit_applicant(id, first_name, last_name){
    // we know which applicant to change using the hidden student_id
    document.getElementById('student_id').value = id;
    console.log('edit: ' + id);
}
</script>
</body>
			};
			#exit 0;
			die 'trying to submit html';
			$dbh2->disconnect();
        }
    }
}

my $fail_html = "<p> failed to authenticate </p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$fail_html
};

print $html_template;
