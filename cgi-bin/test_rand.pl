#!/usr/bin/perl
use strict;
use warnings;

# use unicode from 48 - 122 to avoid errors
my $min = 65;
my $max = 90;

my @i = (0..15);
for(@i){
	print(chr($min + int(rand($max-$min))));
}




