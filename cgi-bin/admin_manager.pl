#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use CGI qw(:standard escapeHTML);
use URI::Escape;
use Digest::SHA qw(sha256_hex);

#Catch data sent from html
my $username = CGI::escapeHTML(param('username'));
my $password = CGI::escapeHTML(param('password'));

# Decode data
$username = uri_unescape( $username );
$password = uri_unescape( $password );

# check if anything is empty
my $err = "<p>Username, salt, or password are empty! Exiting...</p>";
my $html = qq{$err};
if($username eq '' || $password eq ''){
	print $html;
	die 'empty field';
}

# check if a username already exists
my $db_username = 'test';
my $db_pw = 'quakeradmin';
my $db_admiss = 'admissions';
my $db_table_auth = 'auth';
my $dbh = DBI->connect("dbi:mysql:$db_admiss", $db_username, $db_pw);
my $query = "SELECT username, salt, password_hash FROM $db_table_auth";
my $sth = $dbh->prepare($query);
$sth->execute();

# html to generate
$html = qq{
<!DOCTYPE HTML>
<html>
<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
<meta content="utf-8" http-equiv="encoding">
<body>
<h1>Welcome to Phoenix Friend School Admissions</h1>
<h2>Administration Site. Please choose an option below.</h2>
<br>
<button type='button' id='list_all_button' onclick='list_all_applicants()' >List all Applicants</button>
<form action='/cgi-bin/search_applicant.pl' method='post'>
    <label for='search_last_name'>Search for student (last name):</label>
    <input type='text' id='search_last_name' name='search_last_name'></input>
    <input type='submit' value='Submit'>
</form>

<div id='edit_div' style='display: none;'>
    <form action='/cgi-bin/edit_applicant.pl' method='post'>
        <input type='text' id='student_id' name='student_id' style=''>
        <label for='first_name'>First Name:</label>
        <input type='text' id='first_name' name='first_name'>
    <br>
        <label for='last_name'>Last Name:</label>
        <input type='text' id='last_name' name='last_name'>
    <br><br>
        <input type='submit' value='Save'>
    </form>
</div>

<div id='received'></div>

<script>

function list_all_applicants(){
    var xmlHttpReq = false;
    xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.open('POST', '/cgi-bin/list_all_applicants.pl', true);
    xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xmlHttpReq.onreadystatechange = function() {
            if (xmlHttpReq.readyState == 4) {
                console.log("response:");
                console.log(xmlHttpReq.responseText);
                response = xmlHttpReq.responseText;
                document.getElementById("received").innerHTML = response;
            }
        }
    xmlHttpReq.send();
}

function edit_applicant(id){
    // we know which applicant to change using the hidden student_id
    document.getElementById('edit_div').style.display = 'inline';
    document.getElementById('student_id').value = id;
    console.log('edit: ' + id);
}


</script>

</body>
</html>

};
my $doublesha;
my $salt;
# check if username matches computed hash
while( my $row = $sth->fetchrow_hashref ){
	# double sha to check against database
	$salt = $row->{salt};
	my $concat = $password . $salt;
	$doublesha = sha256_hex($concat);
	if( $username eq $row->{username} && $doublesha eq $row->{password_hash}){
		print $html;
		exit 0;
	}
}

# add cookie into table
#$dbh->do("INSERT INTO $db_table_auth (username, salt, password_hash) VALUES (?, ?, ?)", undef, $username, $salt, $doublesha);

my $filename = 'auth_log.txt';
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
print $fh "\nusername: $username";
print $fh "\nsalt: $salt";
print $fh "\npassword: $password";
print $fh "\ndouble sha: $doublesha";
close $fh;

my $html_line = "<p>ACCESS DENIED</p>";

#qq is the same as double quotes: ""
my $html_template = qq{
$html_line
};

print $html_template;



