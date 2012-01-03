eval { require Gtk2::Notify }; 
if($@){
	print "Gtk2::Notify is not installed. Please install it with \'cpan Gtk2::Notify\' or \'sudo apt-get install libgtk2-notify-perl\' or whatever is appropriate for your system.\n";
	die();
}

sub notifier_libnotifyperl { 
  return 1 if(!$ENV{'DISPLAY'});
  my $class = shift;
  my $text = shift;
  my $ref = shift; # not used in this version

  if (!defined($class) || !defined($notify_send_path)) {
    # we are being asked to initialize
    if (!defined($class)) {
      return 1 if ($script);
      $class = 'libnotify-perl support activated';
      $text =
'Congratulations, Gtk2::Notify is correctly configured for TTYtter.';
      Gtk2::Notify->init('ttytter');
      print $text;
    }
  }

  if ( Gtk2::Notify->is_initted() ){
    my $notification = Gtk2::Notify->new(
      "TTYtter: $class",
      $text
    );
    #$notification->set_timeout(1_000); #unnecessary, default is fine
    if($notification->show()){
      #this is debug code more or less
      print "Showed a $class";
    }
  }
  return 1;
}
1;
