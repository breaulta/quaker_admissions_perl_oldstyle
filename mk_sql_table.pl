#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table = 'admiss';

my $dbh = DBI->connect('dbi:mysql:', $db_username, $db_pw);
$dbh->do("CREATE DATABASE IF NOT EXISTS $db_admiss");
$dbh->disconnect;
$dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("CREATE TABLE IF NOT EXISTS $db_table (posting_id INT AUTO_INCREMENT, first_name VARCHAR(100), last_name VARCHAR(100), PRIMARY KEY(posting_id) )");


