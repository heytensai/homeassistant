#!/usr/bin/perl

use strict;
use warnings;

my $dir = "$ENV{HOME}/random-messages";
my $group = shift || exit 1;

my $file = "$dir/$group";
if (!-f $file){
	exit 1;
}

my $count = 0;
open(my $fh, "<", $file) || exit 1;
while (<$fh>){
	$count++;
}
close($fh);
#print STDERR "count=$count\n";
if ($count eq 0){
	exit 1;
}

my $line = int(rand($count));
#print STDERR "line=$line\n";
open($fh, "<", $file) || exit 1;
my $msg;
while (<$fh>){
	if ($line-- eq 0){
		$msg = $_;
		#print STDERR "msg=$msg";
		mqtt_publish($msg);
	}
}
close($fh);

sub mqtt_publish
{
	my $msg = shift;
	if ($msg){
		#print STDERR "mqtt\n";
		open(my $mqtt, "|-", "/usr/bin/mosquitto_pub -r -t message/$group -l");
		print $mqtt $msg;
		close($mqtt);
	}
	exit 0;
}
