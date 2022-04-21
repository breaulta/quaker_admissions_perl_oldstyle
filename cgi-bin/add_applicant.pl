#!/usr/bin/perl
use strict;
use warnings;

use CGI qw(:standard escapeHTML);
use URI::Escape;
use DBI;

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
my $guardian1_address = '';
my $guardian1_city = '';
my $guardian1_zip = '';
my $guardian1_work = '';
my $guardian1_employer = '';
my $guardian2_name = '';
my $guardian2_phone = '';
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

my $first_name = CGI::escapeHTML(param('first_name'));
my $middle_name = CGI::escapeHTML(param('middle_name'));
my $last_name = CGI::escapeHTML(param('last_name'));
my $grade = CGI::escapeHTML(param('grade'));
my $chosen_name = CGI::escapeHTML(param('chosen_name'));
my $main_phone = CGI::escapeHTML(param('main_phone'));
my $address = CGI::escapeHTML(param('address'));
my $city = CGI::escapeHTML(param('city'));
my $zip = CGI::escapeHTML(param('zip'));
my $birthdate = CGI::escapeHTML(param('birthdate'));
my $birth_address = CGI::escapeHTML(param('birth_address'));
my $gender = CGI::escapeHTML(param('gender'));
my $guardian1_name = CGI::escapeHTML(param('guardian1_name'));
my $guardian1_phone = CGI::escapeHTML(param('guardian1_phone'));
my $guardian1_address = CGI::escapeHTML(param('guardian1_address'));
my $guardian1_city = CGI::escapeHTML(param('guardian1_city'));
my $guardian1_zip = CGI::escapeHTML(param('guardian1_zip'));
my $guardian1_work = CGI::escapeHTML(param('guardian1_work'));
my $guardian1_employer = CGI::escapeHTML(param('guardian1_employer'));
my $guardian2_name = CGI::escapeHTML(param('guardian2_name'));
my $guardian2_phone = CGI::escapeHTML(param('guardian2_phone'));
my $guardian2_address = CGI::escapeHTML(param('guardian2_address'));
my $guardian2_city = CGI::escapeHTML(param('guardian2_city'));
my $guardian2_zip = CGI::escapeHTML(param('guardian2_zip'));
my $guardian2_work = CGI::escapeHTML(param('guardian2_work'));
my $guardian2_employer = CGI::escapeHTML(param('guardian2_employer'));
my $prev_school1_name = CGI::escapeHTML(param('prev_school1_name'));
my $prev_school1_phone = CGI::escapeHTML(param('prev_school1_phone'));
my $prev_school1_email = CGI::escapeHTML(param('prev_school1_email'));
my $prev_school1_address = CGI::escapeHTML(param('prev_school1_address'));
my $prev_school2_name = CGI::escapeHTML(param('prev_school2_name'));
my $prev_school2_phone = CGI::escapeHTML(param('prev_school2_phone'));
my $prev_school2_email = CGI::escapeHTML(param('prev_school2_email'));
my $prev_school2_address = CGI::escapeHTML(param('prev_school2_address'));

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("INSERT INTO $db_table_applications (first_name, middle_name, last_name, grade, chosen_name, main_phone, address, city, zip, birthdate, birth_address, gender, guardian1_name, guardian1_phone, guardian1_address, guardian1_city, guardian1_zip, guardian1_work, guardian1_employer, guardian2_name, guardian2_phone, guardian2_address, guardian2_city, guardian2_zip, guardian2_work, guardian2_employer, prev_school1_name, prev_school1_phone, prev_school1_email, prev_school1_address, prev_school2_name, prev_school2_phone, prev_school2_email, prev_school2_address) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", undef, $fname, $lname);


my $filename = 'output.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "First name: $fname";
print $fh "Last name: $lname";
close $fh;

my $q = new CGI;

my $html_line = "<p>You have successfully applied.</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;
