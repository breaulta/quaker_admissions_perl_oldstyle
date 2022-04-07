#!/usr/bin/perl
use strict;
use warnings;

use DBI;

my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table = 'admiss';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
my $query = "SELECT first_name, last_name FROM $db_table";
#statement handle object
my $sth = $dbh->prepare($query);
$sth->execute();
#array of 2 deep arrays
my @student_apps;
while( my $row = $sth->fetchrow_hashref ){
	push(@student_apps, [ $row->{first_name}, $row->{last_name} ]);
}
my $appslist_html = "<p>first name | last name</p>";
foreach my $app_row (@student_apps){
	$appslist_html .= "<br><p>@$app_row[0] | @$app_row[1]</p>";
}
#my $html_line = "<p> this is a line of html programmically inserted </p>";

#qq is the same as double quotes: ""
my $html_template = qq{
<!DOCTYPE HTML>
<html>
<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
<meta content="utf-8" http-equiv="encoding">
<body>
<h1>Welcome to Phoenix Friend School Admissions</h1>
<h2>perl test</h2>
$appslist_html
<br>

</body>
<script>

</script>

</html>

};

print $html_template;
