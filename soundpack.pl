#Sound Pack code by Storm Dragon http://www.stormdragon.us/
#With lots of help from Cameron Kaiser: http://www.floodgap.com/software/ttytter/
#Published under the Floodgap Free Software License: http://www.floodgap.com/software/ffsl/


sub notifier_soundpack
{
        my $class = shift;
        my $text = shift;
        my $ref = shift;
        #Use extpref_sound_command in .ttytterrc to change to appropriate sound system such as ogg123 -q or paplay.
        #is play.
        if (!$extpref_sound_command)
        {
            $soundSystem = "play -q -V0";
        }
        else
        {
            $soundSystem = $extpref_sound_command;
        }
        if (!$extpref_soundpack)
        {
            $soundPath = "default";
        }
        else
        {
            $soundPath = $extpref_soundpack;
        }

        return 1 if ($silent);
        if (!defined($class)) {
                # initialize
                print $stdout "Loaded $soundPath sound pack.\n";
                return 1;
        }
        system("$soundSystem $ENV{'HOME'}/ttytter-extensions/sounds/$soundPath/" . lc($class) . ".ogg");
        return 1;
}
        1;

