#!/usr/bin/perl
use strict;
use warnings;

use CGI qw(:standard escapeHTML);
use URI::Escape;
use DBI;
use Nice::Try;

# Catch auth token
my $auth_token = '';
$auth_token = CGI::escapeHTML(param('auth_token'));
$auth_token = uri_unescape( $auth_token );

my $student_id = '';
my $first_name = '';
my $middle_name = '';
my $last_name = '';
my $grade = '';
my $chosen_name = '';
my $main_phone = '';
my $address = '';
my $city = '';
my $zip = '';
my $birthdate = '';
my $birth_address = '';
my $gender = '';
my $guardian1_name = '';
my $guardian1_phone = '';
my $guardian1_email= '';
my $guardian1_address = '';
my $guardian1_city = '';
my $guardian1_zip = '';
my $guardian1_work = '';
my $guardian1_employer = '';
my $guardian2_name = '';
my $guardian2_phone = '';
my $guardian2_email= '';
my $guardian2_address = '';
my $guardian2_city = '';
my $guardian2_zip = '';
my $guardian2_work = '';
my $guardian2_employer = '';
my $prev_school1_name = '';
my $prev_school1_phone = '';
my $prev_school1_email = '';
my $prev_school1_address = '';
my $prev_school2_name = '';
my $prev_school2_phone = '';
my $prev_school2_email = '';
my $prev_school2_address = '';

$student_id = CGI::escapeHTML(param('student_id'));
$first_name = CGI::escapeHTML(param('first_name'));
$middle_name = CGI::escapeHTML(param('middle_name'));
$last_name = CGI::escapeHTML(param('last_name'));
$grade = CGI::escapeHTML(param('grade'));
$chosen_name = CGI::escapeHTML(param('chosen_name'));
$main_phone = CGI::escapeHTML(param('main_phone'));
$address = CGI::escapeHTML(param('address'));
$city = CGI::escapeHTML(param('city'));
$zip = CGI::escapeHTML(param('zip'));
$birthdate = CGI::escapeHTML(param('birthdate'));
$birth_address = CGI::escapeHTML(param('birth_address'));
$gender = CGI::escapeHTML(param('gender'));
$guardian1_name = CGI::escapeHTML(param('guardian1_name'));
$guardian1_phone = CGI::escapeHTML(param('guardian1_phone'));
$guardian1_email = CGI::escapeHTML(param('guardian1_email'));
$guardian1_address = CGI::escapeHTML(param('guardian1_address'));
$guardian1_city = CGI::escapeHTML(param('guardian1_city'));
$guardian1_zip = CGI::escapeHTML(param('guardian1_zip'));
$guardian1_work = CGI::escapeHTML(param('guardian1_work'));
$guardian1_employer = CGI::escapeHTML(param('guardian1_employer'));
$guardian2_name = CGI::escapeHTML(param('guardian2_name'));
$guardian2_phone = CGI::escapeHTML(param('guardian2_phone'));
$guardian2_email = CGI::escapeHTML(param('guardian2_email'));
$guardian2_address = CGI::escapeHTML(param('guardian2_address'));
$guardian2_city = CGI::escapeHTML(param('guardian2_city'));
$guardian2_zip = CGI::escapeHTML(param('guardian2_zip'));
$guardian2_work = CGI::escapeHTML(param('guardian2_work'));
$guardian2_employer = CGI::escapeHTML(param('guardian2_employer'));
$prev_school1_name = CGI::escapeHTML(param('prev_school1_name'));
$prev_school1_phone = CGI::escapeHTML(param('prev_school1_phone'));
$prev_school1_email = CGI::escapeHTML(param('prev_school1_email'));
$prev_school1_address = CGI::escapeHTML(param('prev_school1_address'));
$prev_school2_name = CGI::escapeHTML(param('prev_school2_name'));
$prev_school2_phone = CGI::escapeHTML(param('prev_school2_phone'));
$prev_school2_email = CGI::escapeHTML(param('prev_school2_email'));
$prev_school2_address = CGI::escapeHTML(param('prev_school2_address'));

$student_id = uri_unescape( $student_id );
$first_name = uri_unescape( $first_name);
$middle_name = uri_unescape( $middle_name);
$last_name = uri_unescape( $last_name);
$grade = uri_unescape( $grade);
$chosen_name = uri_unescape( $chosen_name);
$main_phone = uri_unescape( $main_phone);
$address = uri_unescape( $address);
$city = uri_unescape( $city);
$zip = uri_unescape( $zip);
$birthdate = uri_unescape( $birthdate);
$birth_address = uri_unescape( $birth_address);
$gender = uri_unescape( $gender);
$guardian1_name = uri_unescape( $guardian1_name);
$guardian1_phone = uri_unescape( $guardian1_phone);
$guardian1_email = uri_unescape( $guardian1_email);
$guardian1_address = uri_unescape( $guardian1_address);
$guardian1_city = uri_unescape( $guardian1_city);
$guardian1_zip = uri_unescape( $guardian1_zip);
$guardian1_work = uri_unescape( $guardian1_work);
$guardian1_employer = uri_unescape( $guardian1_employer);
$guardian2_name = uri_unescape( $guardian2_name);
$guardian2_phone = uri_unescape( $guardian2_phone);
$guardian2_email = uri_unescape( $guardian2_email);
$guardian2_address = uri_unescape( $guardian2_address);
$guardian2_city = uri_unescape( $guardian2_city);
$guardian2_zip = uri_unescape( $guardian2_zip);
$guardian2_work = uri_unescape( $guardian2_work);
$guardian2_employer = uri_unescape( $guardian2_employer);
$prev_school1_name = uri_unescape( $prev_school1_name);
$prev_school1_phone = uri_unescape( $prev_school1_phone);
$prev_school1_email = uri_unescape( $prev_school1_email);
$prev_school1_address = uri_unescape( $prev_school1_address);
$prev_school2_name = uri_unescape( $prev_school2_name );
$prev_school2_phone = uri_unescape( $prev_school2_phone );
$prev_school2_email = uri_unescape( $prev_school2_email );
$prev_school2_address = uri_unescape( $prev_school2_address );

my $dbi_error = '';
my $q2;
my $sth2;
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $db_table_session_id = 'Quaker_Session_ID';
# did we catch an auth token?
if ( $auth_token ne '' ){
    #check if it matches a session id in the database
    my $dbh2 = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
    $q2 = "SELECT session_id FROM $db_table_session_id";
    $sth2 = $dbh2->prepare($q2);
    $sth2->execute();
    while( my $row = $sth2->fetchrow_hashref ){
        # we've now authenticated using auth token
        if( $auth_token eq $row->{session_id}){
			# set raiseerror to ensure application makes it to the database
			my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw, {RaiseError => 1,});
			try {
				$dbh->do("UPDATE $db_table_applications SET first_name=?, middle_name=?, last_name=?, grade=?, chosen_name=?, main_phone=?, address=?, city=?, zip=?, birthdate=?, birth_address=?, gender=?, guardian1_name=?, guardian1_phone=?, guardian1_email=?,guardian1_address=?, guardian1_city=?, guardian1_zip=?, guardian1_work=?, guardian1_employer=?, guardian2_name=?, guardian2_phone=?, guardian2_email=?,guardian2_address=?, guardian2_city=?, guardian2_zip=?, guardian2_work=?, guardian2_employer=?, prev_school1_name=?, prev_school1_phone=?, prev_school1_email=?, prev_school1_address=?, prev_school2_name=?, prev_school2_phone=?, prev_school2_email=?, prev_school2_address=? WHERE student_id=?", undef, $first_name, $middle_name, $last_name, $grade, $chosen_name, $main_phone, $address, $city, $zip, $birthdate, $birth_address, $gender, $guardian1_name, $guardian1_phone, $guardian1_email, $guardian1_address, $guardian1_city, $guardian1_zip, $guardian1_work, $guardian1_employer, $guardian2_name, $guardian2_phone, $guardian2_email, $guardian2_address, $guardian2_city, $guardian2_zip, $guardian2_work, $guardian2_employer, $prev_school1_name, $prev_school1_phone, $prev_school1_email, $prev_school1_address, $prev_school2_name, $prev_school2_phone, $prev_school2_email, $prev_school2_address, $student_id );
			}
			catch ($e) {
				$dbi_error = "caught error: $e";
			}
		}
	}
}
my $html_line = '';
if ($dbi_error ne ''){
	$html_line = $dbi_error . "\n\n Please go back in your browser and fix the error";
}else{
	my $file = 'html_files/return_admin.html';
	print_auth_html($auth_token, $file);
}

#qq is the same as double quotes: ""
my $html_template = qq{
<p>$html_line</p>
};

print $html_template;


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
	print "<p>You have successfully updated the application.</p>";
    exit 0;
}



