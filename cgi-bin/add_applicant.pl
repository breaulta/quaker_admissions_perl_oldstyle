#!/usr/bin/perl
use strict;
use warnings;

use CGI qw(:standard escapeHTML);
use DBI;

my $fname = CGI::escapeHTML(param('first_name'));
my $lname = CGI::escapeHTML(param('last_name'));

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table = 'admiss';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
$dbh->do("INSERT INTO $db_table (first_name, last_name) VALUES (?, ?)", undef, $fname, $lname);


my $filename = 'output.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "First name: $fname";
print $fh "Last name: $lname";
close $fh;

my $q = new CGI;

my $html_line = "<p> this is a line of html programmically inserted </p>";

#qq is the same as double quotes: ""
my $html_template = qq{
<!DOCTYPE HTML>
<html>
<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
<meta content="utf-8" http-equiv="encoding">
<body>
<h1>Welcome to Phoenix Friend School Admissions</h1>
<h2>perl test</h2>
$html_line
<p>next line</p>
<br>

</body>
<script>

</script>

</html>

};

print $html_template;
