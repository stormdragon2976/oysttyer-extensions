#Client.pl extension code by Storm Dragon http://www.stormdragon.us/
#With lots of help from Cameron Kaiser: http://www.floodgap.com/software/ttytter/
#Published under the Floodgap Free Software License: http://www.floodgap.com/software/ffsl/

#What is it?
#This extension shows the clients people use to post to Twitter.
#for example, if someone posts from TTYtter you will see the tweet text followed by
#From TTYtter

#Usage:
#This extension works automatically. Either call it when running TTYtter or add it to your ext line in your !/.ttytterrc
#for more information on extensions visit http://www.floodgap.com/software/ttytter/adv.html

$handle = sub {
        my $ref = shift;
        my $class = shift;
        my $source = $ref->{'source'};
        # do this first for installs with -seven
        $source =~ s/\\u003[cC]/</g;
        $source =~ s/\\u003[eE]/>/g;
        $source = &descape($source);
        $source =~ s/<[^>]+>//g;
        $source =~ s/&lt;/</g;
        $source =~ s/&gt;/>/g;
        $source =~ s/ \([^\)]+\)//g;
        print $streamout ($ref->{'menu_select'} . "> ".
                &standardtweet($ref) .  "    From " . &descape($source) . ".\n");
        &sendnotifies($ref, $class);
        return 1;
};
