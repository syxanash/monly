package Monly::Airport;
use strict;
use warnings;

# Logger is required to write info in log file
use Monly::Logger qw{ log_it };

use IPC::System::Simple qw(capture);

=head1 NAME

Monly::Airport - Monly interface to airport tool

=head1 DESCRIPTION

This module works as an interface for Mac OS X tool airport.
You'll be able to get airport current status which could be set
to On or Off. You can enable aiport if it is currently disabled or
you can try to establish a connection to a open wifi access point.

=cut

use base 'Exporter';

our @EXPORT_OK = qw{};
our @EXPORT    = qw{
  toggle_airport
  try_connection
  airport_status };

=head1 SYNOPSIS

    use Monly::Airport;

    if ( airport_status() eq 'Off' ) {
        toggle_airport();
        try_connection();
    }

=head1 EXPORT

=over 4

=item * toggle_airport: switch airport status to On if current status is Off

=item * try_connection: look for open wifi networks and try to establish a connection if access point is found

=item * airport_status: get current status of airport (On or Off)

=back

=head1 SUBROUTINES/METHODS

=head2 toggle_airport

Get current status of airport and turns it on if not enabled
waits a few seconds in order to make airport ready

=cut

sub toggle_airport {

    # toggle airport on and off

    if ( airport_status() eq 'Off' ) {
        system '/usr/sbin/networksetup -setairportpower en1 on 2> /dev/null';

        # let's wait a few seconds just to make sure
        # airport is ready

        log_it("[?] turn on wifi...\n");

        sleep( int( rand(20) ) + 5 );
    }
}

=head2 try_connection

Look for available access point without security and
try to establish a connection automatically

=cut

sub try_connection {

    my $temp_output;

    chomp(
        $temp_output = capture("/usr/sbin/airport -s | grep NONE | sort -k3 -r | head -1 | cut -c1-32 | sed 's/^[ \\t]*//'")
    );

    if ($temp_output) {
        system '/usr/sbin/networksetup -setairportnetwork en1 '
          . $temp_output
          . ' 2>/dev/null';
    }
    else {
        log_it("[?] No open networks were found...\n");
    }
}

=head2 airport_status

Return: networksetup command output.
Check status of airport (On or Off)

=cut

sub airport_status {
    my $temp_output = q{};

    # check airport status

    chomp(
        $temp_output = capture('/usr/sbin/networksetup -getairportpower en1 2> /dev/null | awk \'{print $4}\'')
    );

    return $temp_output;
}

=head1 DEPENDENCIES

Monly::Airport needs Monly::Logger::log_it()

=over 4

=item * Monly::Logger

L<Monly::Logger>

=back

=head1 AUTHOR

syxanash, C<< <syxanash at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Airport


You can also look for information at:

=over 4

=item * airport: Airport Utility

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/airport.8.html>

=item * networksetup: configuration tool for network on Mac OS X

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html>

=item * IPC::System::Simple

L<IPC::System::Simple>

=back

=cut

1;