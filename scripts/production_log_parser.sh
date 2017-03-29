#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;

my $LOGFILE = "production.log";
my $ERRORFILE = "badcalls.txt";
my %calls = ();
my $key;

open(my $LF, '<', $LOGFILE) or die "Could not open file '$LOGFILE' $!";
open(my $EF, '>', $ERRORFILE) or die "Could not open file '$ERRORFILE' $!";

foreach my $line (<$LF>) {
 chomp($line);              # remove the newline from $line.
# say ($line);
 my($errorBit, $timeStamp, $key, $message) = split(' ',$line,4);

 if($errorBit eq "E" || $errorBit eq "I") {
#  say ($key);

  # Populate hash table of api calls from above log file  
  if($message =~ /^Started/)
   {
   my @message = split(' ',$message,4);
   my $api = $message[2];
   $api =~ s/["]//g;
   push @{$calls{$key}}, $api;
  }

  if($message =~ /^Completed/)
   {
   my @message = split(' ',$message,6);
   my $responseTime = $message[4];
   $responseTime =~ s/['ms']//g; 
   push @{$calls{$key}}, $responseTime;
  }


 } else {
  print $EF $line;
 }

}

close $LF;
close $EF;

my %apiList = ();

# sort and group table based on api call and response time
for $key (keys %calls){
# print "$key: Api: $calls{$key}[0] Response Time: $calls{$key}[1]   \n";
 push @{$apiList{$calls{$key}[0]}}, $calls{$key}[1];
}

# print stats for overall api usage
for my $unqApi (keys %apiList){
# print "Api: $unqApi @{ $apiList{$unqApi} }\n";
 my $num = @{$apiList{$unqApi}};
 my $total = sum($apiList{$unqApi});
 my $avg = $total/$num;
 print "Api: $unqApi \t\t Total calls: $num \t Average: $avg \n";
}

sub sum{
 my @array = @{(shift)};
 my $total = 0;
 foreach (@array) {
#  print "From sub-array: $_\n";
  $total = $total + $_;
  }
 return $total;
}


