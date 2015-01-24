#!/usr/bin/perl

use strict;
use warnings;

# required modules for checking mails
use Net::IMAP::Simple;
use Email::Simple;
use IO::Socket::SSL;

# for sending mails
use Email::Send;
use Email::Send::Gmail;
use Email::Simple::Creator;


# fill in your details here
my $username = 'SecretMRRMailAddress@gmail.com';
my $password = 'YourPasswordForThatAccount';
my $mailhost = 'imap.gmail.com';

my $mainmailaddr = 'MailAddressYouWantNotificationsTo@gmail.com';

# Connect
my $imap = Net::IMAP::Simple->new(
    $mailhost,
    port    => 993,
    use_ssl => 1,
) || die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

# Log in
if ( !$imap->login( $username, $password ) ) {
    print STDERR "Login failed: " . $imap->errstr . "\n";
    exit(64);
}
# Look in the the INBOX
my $nm = $imap->select('INBOX');

# How many messages are there?
my ($unseen, $recent, $num_messages) = $imap->status();
print "unseen: $unseen, recent: $recent, total: $num_messages\n\n";


## Iterate through unseen messages
for ( my $i = 1 ; $i <= $nm ; $i++ ) {
    if ( $imap->seen($i) ) {
        next;
    }

    else {
    my $es = Email::Simple->new( join '', @{ $imap->top($i) } );

    printf( "[%03d] %s\n\t%s\n", $i, $es->header('From'), $es->header('Subject') );

    if ($es->header('From') =~ /miningrigrentals|ranseier|gmx/)
	{
		#print "We have found a matching, unread email !\n";
		my $message = $imap->get($i);
       		$message = "$message"; # our message
		#printf ("The message is: $message");
		if( $message =~ /OCID:(.+?)]/i ) {
  			my $rigid = $1;
			my $do = "start";
			#printf("The rigid is: $rigid\n");

			if ($message =~ /STOP!/) {
				printf("STOP! Word found in E-Mail !\n");
				$do = "stop";
			}

			&dorigwork($rigid,$do);
			#$imap->put( "Heimdall", $i) or warn $imap->errstr;
		}

	}


    }
}


# Disconnect
$imap->quit;

exit;



sub dorigwork
{

	#printf("Rigname: $_[0] Status: $_[1]\n");

	my $filefound = 'Not found!';
	my $filename = "/home/pi/MRR/Rigs/"."$_[0]"."-"."$_[1]".".pl"; 
	printf("Searching for filename: $filename\n");

	if (-e $filename) { 
		print "$filename exists, launching now !\n"; 
		system($filename);
		$filefound = 'Found, launching !';
	}



	# send confirmation email

	printf("Sending mail ! \n");

	my $email = Email::Simple->create(
	header => [
          From    => "$username",
          To      => "$mainmailaddr",
          Subject => "Rig $_[0] Status: $_[1]",
	],
	body => "$filename \n $filefound \n \n Greets, MRR-Heimdall & Suprnova",
	);


	my $sender = Email::Send->new(
          {   mailer      => 'Gmail',
              mailer_args => [
                username => "$username",
                password => "$password",
              ]
          }
	);

	eval { $sender->send($email) };



}


