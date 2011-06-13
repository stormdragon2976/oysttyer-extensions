# Command to check the current rate limit status
#
# Copyright 2009 Peter Reuterås
#
# License: GPL v2
#
#

#Usage:
#This extension adds the /limit command.
#for more information on extensions visit http://www.floodgap.com/software/ttytter/adv.html

$addaction = sub {
	my $command = shift;

	if ($command =~ s#^/limit##) {
		my $result = &grabjson("$rlurl");
		if (defined($result) && ref($result) eq 'HASH') {
			my $reset_time_in_seconds=$result->{'reset_time_in_seconds'};
			(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,
				my $isdst)=localtime($reset_time_in_seconds);
			my $reset_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d", 
				$year+1900,$mon+1,$mday,$hour,$min,$sec;
			print "Remaining hits ".$result->{'remaining_hits'}.", resets at ".
				$reset_time.". Hourly limit is ".$result->{'hourly_limit'}.".\n";
			return 1;
      }
	}
	return 0;
};


