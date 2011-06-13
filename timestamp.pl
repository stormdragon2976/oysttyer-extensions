#This code modified by Storm Dragon: http://www.stormdragon.us/
#Original code available at http://www.kosertech.com/tools/extending-ttytter/


#What is it?
#This extension adds timestamps before tweets if 5 minutes or more have passed.

#Usage:
#This extension works automatically. Just call it when you load TTYtter or add it to your ~/.ttytterrc
#for more information on extensions visit http://www.floodgap.com/software/ttytter/adv.html

$handle = sub {

my $delayInSeconds = 60 * 5;
my ($nsec,$nmin,$nhour,$nday,$nmon,$nyear) = localtime(time);

#load the Lib_past with current time on first run
if(!$Lib_firstrun){
     $Lib_firstrun = true;
     print "Seeding timestamp generator\n";
     $Lib_past = time;
}

#if we have elapsed $delayInSeconds then print a time stamp
if($Lib_past < (time - ($delayInSeconds))){
     $Lib_past = time;
     my $timeString = "-- ";
     my $timeOfDay = "AM";
     if ($nhour >= 12)
     {
          if ($nhour > 12)
          {
               $nhour = $nhour - 12;
          }
          $timeOfDay = "PM";
     }
     if (($nhour < 10) && ($nhour != 0))
     {
          $timeString .= "0";
     }
     if ($nhour == 0)
     {
          $nhour = 12;
          $timeOfDay = "AM";
     }
     $timeString .= "$nhour:";
     if ($nmin < 10)
     {
          $timeString .= "0";
     }
     $timeString .= "$nmin$timeOfDay";
          print $timeString . " --\n";
}

#this allows TTYtter to handle displaying the tweet normally
my $ref = shift;
&defaulthandle($ref);

return 1;

};

