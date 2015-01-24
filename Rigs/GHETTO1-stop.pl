#!/usr/bin/perl

use Time::HiRes;


$newstate=$ARGV[0];

use Device::Gembird;

    my $stk1 = Device::Gembird->new( host => '192.168.9.11', secret => 'pass1234' );
    my $stk2 = Device::Gembird->new( host => '192.168.9.12', secret => 'pass1234' );
    my $stk3 = Device::Gembird->new( host => '192.168.9.13', secret => 'pass1234' );
    my $stk4 = Device::Gembird->new( host => '192.168.9.14', secret => 'pass1234' );
    my $stk5 = Device::Gembird->new( host => '192.168.9.229', secret => 'pass1234' );

	$stk1->socket1(SOCK_OFF); 
	Time::HiRes::sleep(0.5);
	$stk2->socket1(SOCK_OFF);
	Time::HiRes::sleep(0.5);
	$stk3->socket1(SOCK_OFF);
	Time::HiRes::sleep(0.5);
	$stk4->socket1(SOCK_OFF);
	Time::HiRes::sleep(0.5);
        $stk5->socket1(SOCK_OFF);
        Time::HiRes::sleep(0.5);
	
#    my $state = $stk1->socket3();
#    my $new_state = $stk1->socket4(SOCK_ON);
#	print "State: $newstate\n";

