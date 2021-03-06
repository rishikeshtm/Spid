#!/usr/bin/env perl -w

use strict;
use warnings;

use feature ':5.10';

#additional header for sockets handling 
use IO::Socket; 
#used for the function gethostbyaddr 
use Net::hostent; 

#you have to specify the port number after the perl command 
my $port=shift || die "Usage server.pl <port>\n"; 

#### 
#creation of the socket called $server: 
#Proto= protocol to use 
#LocalPort = service name or port number to be the server 
#ports < 1024 under linux are restricted to the superuser 
#Listen = number of pending connections, SOMAXCON is 
#a special symbol for the system maximum 
#Reuse = restart the server manually 
#### 

my $server = IO::Socket::INET->new( Proto => 'tcp', 
                                    LocalPort => $port, 
                                    Listen => SOMAXCONN, 
                                    Reuse => 1); 

die "can't setup server" unless $server; 
print "[Server $0 is running]\n"; 

#### 
#the server waits for a client to connect 
#and accept it with $server->accept 
#you can telnet to the port you want to test it 
#### 

 while (my $client = $server->accept()) { 
   
   $client->autoflush(1); 
   
   #welcome 
   #### 
   #get informations on the client 
   #peeraddr = client name or IP 
   #### 
   #print this informations on the server side 
   printf "[Connect from %s]\n", $client->peerhost; 
   
   #ask the client for a command 
   #print $client "[server]\$"; 
   
   while (<$client>) {
       if (/exit/i) {
           last;
       }
       else {
           print $client "$_";
       }
   } 
   
   close $client; 
 } 
#the socket $client is closed 
#to close the socket $server: ctrl+c 
