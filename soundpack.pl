#Sound Pack code by Storm Dragon http://www.stormdragon.us/
#With lots of help from Cameron Kaiser: http://www.floodgap.com/software/ttytter/
#Published under the Floodgap Free Software License: http://www.floodgap.com/software/ffsl/


#What is it?
#This extension notifies you of new tweets using sounds.
#There are different sounds for different types of notifications, replies and dms sound different from standard tweets.

#Usage:
#This extension works automatically. Just call it when you run TTYtter or add it to your ext line in your ~/.ttytterrc
#This extension uses 2 settings that can optionally be added to your ~/.ttytterrc
#extpref_soundpack=soundpack_name
#extpref_sound_command=sound-command for example, sox users would use:
#extpref_sound_command=play -q
#for more information on extensions visit http://www.floodgap.com/software/ttytter/adv.html

sub notifier_soundpack
{
        my $class = shift;
        my $text = shift;
        my $ref = shift;
        #Use extpref_sound_command in .ttytterrc to change to appropriate sound system such as ogg123 -q or paplay for pulseaudio.
the default is play -q which requires sox be installed.
        if (!$extpref_sound_command)
        {
            $soundSystem = "play -q";
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

