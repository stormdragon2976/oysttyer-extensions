###################
#
# ttytter-r2a.pl -- a TTYtter extension
# 
# 	Copyright (C) 2011 by Ben Cotton
#
# 	See README.txt for more information
#
# 	Licensed under GNU Public License v2.0. See LICENSE for full text.
#
###################

$TTYtter_R2A_VERSION='1.0';

$addaction = sub {
    my @command = split(/ /,$_,3);

	# Check to see what command was given
    if ( ( lc($command[0]) eq '/replyall' ) || 
			( lc($command[0]) eq '/ra' )  ||
			( lc($command[0]) eq '/replytoall' ) ) {

		# Get information about the tweet
		my $tweet_id = $command[1];
		my $tweet = &get_tweet($tweet_id);
        my $witty_reply = $command[2];

		# Check that the tweet exists. If not, it will be hard to reply to it.
		if (!$tweet->{'id_str'}) {
            print $stdout "-- You have to wait for that tweet to exist!\n";
            return 1;
        }

		# Who sent the tweet that we're replying to?
		$screen_name = &descape($tweet->{'user'}->{'screen_name'});

		# Who is mentioned in the tweet?
		my $reply_tweet = $tweet->{'text'};
		my $mentioned;
		# We iterate over the string because I can't think of a better way
		while ( $reply_tweet =~ m/(@\w+)/g ) {
			# Don't add yourself to the reply list, or the person you're
			# replying to, since they'll be added anyway
			unless ( ( lc($1) eq lc("\@$whoami") ) || 
					 ( lc($1) eq lc("\@$screen_name") ) ) {
				$mentioned .= "$1 ";
			}
		}

		# We're replying, so we'd better act like it
		$in_reply_to = $tweet->{'id_str'};

		# Prepend the tweet with the names to mention
		$witty_reply = "\@$screen_name $mentioned $witty_reply";
		&common_split_post($witty_reply, $in_reply_to, undef);
		# All done!
		return 1;
    }

	# You didn't ask to reply to all. Tell TTYtter that we don't want to deal
	# with this input.
	return 0;
};
