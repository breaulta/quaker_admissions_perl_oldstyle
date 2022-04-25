#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $db_table_auth = 'auth';
my $db_table_session_id = 'Quaker_Session_ID';

# Create master database
my $dbh = DBI->connect('dbi:mysql:', $db_username, $db_pw);
$dbh->do("CREATE DATABASE IF NOT EXISTS $db_admiss");
$dbh->disconnect;

# Create table to hold applications.
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table_applications (student_id INT AUTO_INCREMENT, first_name VARCHAR(30), middle_name VARCHAR(30), last_name VARCHAR(30), grade VARCHAR(1), chosen_name VARCHAR(20), main_phone VARCHAR(20), address VARCHAR(50), city VARCHAR(20), zip VARCHAR(10), birthdate VARCHAR(10), birth_address VARCHAR(80), gender VARCHAR(20), guardian1_name VARCHAR(50), guardian1_phone VARCHAR(20), guardian1_address VARCHAR(80), guardian1_city VARCHAR(20), guardian1_zip VARCHAR(10), guardian1_work VARCHAR(20), guardian1_employer VARCHAR(30), guardian2_name VARCHAR(30), guardian2_phone VARCHAR(20), guardian2_address VARCHAR(50), guardian2_city VARCHAR(20), guardian2_zip VARCHAR(10), guardian2_work VARCHAR(20), guardian2_employer VARCHAR(30), prev_school1_name VARCHAR(50), prev_school1_phone VARCHAR(20), prev_school1_email VARCHAR(50), prev_school1_address VARCHAR(90), prev_school2_name VARCHAR(50), prev_school2_phone VARCHAR(20), prev_school2_email VARCHAR(50), prev_school2_address VARCHAR(80), PRIMARY KEY(student_id) )");
$dbh->disconnect;

# Create table to handle admin authorization.
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table_auth (user_id INT AUTO_INCREMENT, username VARCHAR(100), salt VARCHAR(100), password_hash VARCHAR(64), PRIMARY KEY(user_id) )");
$dbh->disconnect;

# Create table to handle auth tokens.
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table_session_id (id INT AUTO_INCREMENT, session_id VARCHAR(20), PRIMARY KEY(id) )");


