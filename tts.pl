#tts.pl extension code by Storm Dragon http://www.stormdragon.us/
#Published under the Floodgap Free Software License: http://www.floodgap.com/software/ffsl/

#What is it?
#This extension uses text to speech to read incoming Tweets.
#Several voices are available.

#Usage:
#You can toggle the extension on and off by using the added /tts command.
#Help is available when the extension is loaded with the added "/tts help" command
#Call this extension when you run TTYtter or by adding it to your ext line in your ~/.ttytterrc


$addaction = sub {
        my $command = shift;
        my $speak = "";
        #Get the current state, tmp solution.
        if (-e "$ENV{'HOME'}/ttytter-extensions/tts.txt")
        {
            open TTSSETTINGS, "$ENV{'HOME'}/ttytter-extensions/tts.txt";
            $speak = <TTSSETTINGS>;
            close $TTSSETTINGS;
            }
        else
        {
            $speak = 0;
        }
        if ($command eq '/tts')
        {
            if ((!defined($speak)) || ($speak eq 1))
            {
                $speak = 0;
                print $streamout ("Speech disabled\n");
            }
            else
            {
                $speak = 1;
                print $streamout ("Speech enabled\n");
            }
            #write the new value:
            open TTSSETTINGS, ">$ENV{'HOME'}/ttytter-extensions/tts.txt";
            print TTSSETTINGS "$speak";
            close TTSSETTINGS;
            return 1;
        }
        if ($command eq "/tts help")
        {
            my $ttsHelp = "Text to Speech\n\nToggle speech on and off:  /tts\nGet help:  /tts help\n\nSynthesizer settings:\n\nSettings are placed in a .ttytterrc file:\n\nextpref_tts_synthesizer=synthName where synthName is:\ncepstral, espeak (default), festival, mac, or pico\nextpref_tts_language=languageCode where languageCode is the code of the language you want to use (default is en-us):\nSupported synthesizers for this setting are espeak and pico\nextpref_tts_rate=number where number is how fast you want the synthesizer to speak (default is 175):\nSupported by espeak only for now.\nextpref_tts_variant=name where name is the name of a variant you want to use (no default):\nEspeak has several variants you can use as well as a language setting. In cepstral and mac it is the name of the voice you\nwish to use.\nIf you don't specify a variant it will just use the\ndefault voice.\n";
            print $streamout ("$ttsHelp");
            return 1;
        }
        return 0;
        };

$handle = sub {
        my $ref = shift;
        my $class = shift;
        #Don't read all tweets at start up, takes forever.
        if ($last_id eq 0)
        {
            &defaulthandle($ref);
            return 1;
        }
        my $speak = "";
        #get the value of speak from flat file. Temp fix:
        if (-e "$ENV{'HOME'}/ttytter-extensions/tts.txt")
        {
            open TTSSETTINGS, "$ENV{'HOME'}/ttytter-extensions/tts.txt";
            $speak = <TTSSETTINGS>;
            close $TTSSETTINGS;
            }
        else
        {
            $speak = 0;
        }
        #Initialize variables to keep local scope
        #Pulse is most common so is default.
        my $soundCommand = "paplay";
        my $synthesizer = "";
        my $language = "";
        my $variant = "";
        my $rate = "";
        my $speechCommand = "";
        #Check if we need a different sound command
        if ($extpref_sound_command)
        {
            $soundCommand = "$extpref_sound_command";
        }

        #set our speech synthesizer
        #available choices are:
        #cepstral, espeak, festival, mac, pico
        if (!$extpref_tts_synthesizer)
        {
            $synthesizer = "espeak";
        }
        else
        {
            $synthesizer = $extpref_tts_synthesizer;
        }
        #Set the language to be used
        if (!$extpref_tts_language)
        {
            $language = "en-US";
        }
        else
        {
            $language = $extpref_tts_language;
        }
        #Set the variant to be used (Cepstral, Espeak, and Mac)
        #Only set if in .ttytterrc
        if ($extpref_tts_variant)
        {
            $variant = "$extpref_tts_variant";
        }
        if ($extpref_tts_rate)
        {
            $rate = $extpref_tts_rate;
        }
        my $tweetText = &descape($ref->{'user'}->{'screen_name'}) . " " . &descape($ref->{'text'});
        #Make speech more friendly.
        #This first line is so that quotes will not crash speech
        $tweetText =~ s/\"/ /g;
        #Replace space # with the words hash tag
        $tweetText =~ s/ \#/ hash tag /g;
        #Hopefully make links read a little better.
        $tweetText =~ s/http:\/\//link /g;
        $tweetText =~ s/www./ /g;
        $tweetText =~ s/is.gd/i s dot g d /g;
        $tweetText =~ s/\// forward slash /g;
        $tweetText =~ s/\\/ back slash /g;
        $tweetText =~ s/lol/ laughs out loud /gi;
        $tweetText =~ s/rofl/ rolling on the floor laughing /gi;
        #End speech string replacement section
        #Set up the speech command
        #cepstral
        if ($synthesizer eq "cepstral")
        {
            #Requires alsa-oss to be installed in Ubuntu.
            $speechCommand = "aoss swift ";
            #If voice is specified add the voice to the command.
            if ($variant != "")
            {
                $speechCommand .= "-n $variant ";
            }
            $speechCommand .= "\"$tweetText\"";
        }
        #espeak
        if ($synthesizer eq "espeak")
        {
            #If espeak rate is not set make default of 175.
            if ($rate eq "")
            {
                $rate = "175";
            }
            $speechCommand = "$synthesizer -v " . lc($language);
            if ($variant ne "")
            {
                $speechCommand .= "+$variant";
            }
            $speechCommand .= " -s $rate \"$tweetText\"";
        }
        #festival
        if ($synthesizer eq "festival")
        {
            #festival settings should be controled in a file: /etc/festival.scm
            #for a good sample festival.scm file:
            #http://ubuntuforums.org/showthread.php?t=751169
            $speechCommand = "echo \"$tweetText\" | festival --tts";
        }
        #mac
        if ($synthesizer eq "mac")
        {
            $speechCommand = "say ";
            #If voice is set add the option to the speech command:
            if ($variant ne "")
            {
                $speechCommand .= "-v $variant ";
            }
            $speechCommand .= "\"$tweetText\"";
        }
        #pico
        if ($synthesizer eq "pico")
        {
            $speechCommand = "pico2wave -l $language -w /tmp/TTYtter.wav \"$tweetText\" && $soundCommand /tmp/TTYtter.wav";
        }
        if ($speak eq 1)
        {
            system("$speechCommand");
        }
#        print $streamout ("Speech command is:\n$speechCommand\n");
        &defaulthandle($ref);
        return 1;
};
