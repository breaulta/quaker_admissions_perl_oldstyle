#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_applications = 'applications';
my $db_table_auth = 'auth';

# Create master database
my $dbh = DBI->connect('dbi:mysql:', $db_username, $db_pw);
$dbh->do("CREATE DATABASE IF NOT EXISTS $db_admiss");
$dbh->disconnect;

# Create table to hold applications.
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table_applications (student_id INT AUTO_INCREMENT, first_name VARCHAR(100), last_name VARCHAR(100), PRIMARY KEY(student_id) )");

# Create table to handle admin authorization.
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table_auth (user_id INT AUTO_INCREMENT, username VARCHAR(100), salt VARCHAR(100), password_hash VARCHAR(64), cookie VARCHAR(4100), PRIMARY KEY(user_id) )");




