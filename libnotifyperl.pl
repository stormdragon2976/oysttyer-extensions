#Install libgtk2-notify-perl
eval('use Gtk2::Notify') || print "Gtk2::Notify is not installed. Please install it with \'cpan Gtk2::Notify\' or \'sudo apt-get install libgtk2-notify-perl\' or whatever is appropriate for your system.\n";

sub notifier_libnotifyperl {
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
    }
  }

	my $notification = Gtk2::Notify->new(
    "TTYtter: $class",
    $text
  );
	$notification->show;
  return 1;
}
1;
