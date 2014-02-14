package Monly::Getter;
use strict;
use warnings;

# NetStuff is required to get geolocation info
use Monly::NetStuff qw{ is_up get_content };

# Logger is required to write info in log file
use Monly::Logger qw{ log_it };

use JSON;
use IPC::System::Simple qw{ capture };

=head1 NAME

Monly::Getter - Get things

=head1 DESCRIPTION

Get information using tools.

=cut

use base 'Exporter';

our @EXPORT_OK = qw{ speak_to_thief };
our @EXPORT    = qw{
  get_picture
  get_desktop
  get_local_info
  get_info
  get_history_download };

=head1 SYNOPSIS

    use Monly::Getter;
    
    my $info_location = get_info();
    my $device_info   = get_local_info();

    my $picture_path = get_picture();
    my $desktop_pic  = get_desktop();

    my $history_download = get_history_download();

=head1 EXPORT

=over 4

=item * get_info: get geolocation info

=item * get_local_info: get network configuration info

=item * get_picture: take iSight photo with imagensap

=item * get_desktop: take desktop screenshot with screencapture

=item * get_history_download: get downloads history with sqlite3

=back

=head1 SUBROUTINES/METHODS

=head2 get_info

Use LWP::UserAgent to connect to various geolocation
web sites and geolocate ip address with related JSON API.

=cut

sub get_info {
    my @geo_locator_sites = (
        'http://www.telize.com/geoip', 'http://freegeoip.net/json/',
        'http://httpbin.org/ip',
    );

    my ( $info_location_hash, $info_content );

    # check which one of the geo location sites is available

    foreach (@geo_locator_sites) {
        if ( is_up($_) ) {
            $info_location_hash = decode_json( get_content($_) );
            last;
        }
    }

    # if all websites are oddly down, you're fucked!

    $info_location_hash->{'information'} = 'NOT AVAILABLE'
      unless ($info_location_hash);

    # beautify final output

    foreach ( keys %{$info_location_hash} ) {
        $info_content .= ucfirst $_ . ': ' . $info_location_hash->{$_} . "\n";
    }

    return $info_content;
}

=head2 get_local_info

Get information such as ethernet
mac address and wifi device mac address.
Toggle wifi on if turned off. Create
access points list using airport --scan command

=cut

sub get_local_info {
    my %hardware_info;
    my ( $temp_output, $various_info );

    # FETCH MAC ADDRESS FOR ETH0

    chomp( $temp_output = capture('/usr/sbin/networksetup -getmacaddress en0 | awk \'{print $3 " " $4 " " $5}\' 2> /dev/null') );

    $hardware_info{eth_mac} = $temp_output;

    # FETCH MAC ADDRESS FOR WIFI

    chomp( $temp_output = capture('/usr/sbin/networksetup -getmacaddress en1 | awk \'{print $3 " " $4 " " $5}\' 2> /dev/null') );
    $hardware_info{wifi_mac} = $temp_output;

    # FETCH SUBNET MASK

    chomp( $temp_output = capture('/usr/sbin/ipconfig getoption en1 subnet_mask 2> /dev/null') );
    $hardware_info{subnet} = $temp_output;

    # FETCH ROUTER ADDRESS

    chomp( $temp_output = capture('/usr/sbin/ipconfig getoption en1 router 2> /dev/null') );
    $hardware_info{gateway} = $temp_output;

    # FETCH DNS

    chomp( $temp_output = capture('/usr/sbin/ipconfig getoption en1 domain_name_server 2> /dev/null') );
    $hardware_info{dns} = $temp_output;

    # FETCH LIST OF ACCESS POINTS

    chomp( $temp_output = capture('/usr/sbin/airport --scan 2> /dev/null') );
    $hardware_info{ap_list} = $temp_output;

    # beautify final output

    foreach ( keys %hardware_info ) {
        $various_info .= ucfirst($_) . ":\n" . $hardware_info{$_} . "\n\n";
    }

    return $various_info;
}

=head2 get_picture

Take pictures with imagesnap and
temporarily save file in /tmp/
Return picture name generated.

=cut

sub get_picture {
    my $picture_name = '/tmp/' . time() . '_isight_monly.jpg';

    system( '/usr/local/bin/imagesnap ' . $picture_name . ' &> /dev/null' ) == 0
      or log_it("[!] Capture was halted!\n");

    log_it("[!] Can't locate picture path!\n")
      unless -e $picture_name;

    return $picture_name;
}

=head2 get_desktop

Get desktop picture with screencapture
save result it in /tmp/

=cut

sub get_desktop {
    my $picture_name = '/tmp/' . time() . '_desktop_monly.jpg';

    system '/usr/sbin/screencapture -x ' . $picture_name . ' 2> /dev/null';

    log_it("[!] Can't locate desktop picture!\n")
      unless -e $picture_name;

    return $picture_name;
}

=head2 get_history_download

Get history of all downloads on your Mac.

=cut

sub get_history_download {
    my $temp_output;
    my $history_file = '/tmp/' . time() . '_history_monly.txt';

    chomp(
        $temp_output = capture(
'/usr/bin/sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* \'select LSQuarantineDataURLString from LSQuarantineEvent\' | sort > '
              . $history_file
              . ' 2> /dev/null'
        )
    );

    return $history_file;
}

=head2 speak_to_thief

use PlainTalk with Zarvox voice to
speak directly to the thief.
If this works, it is fucking awesome!

=cut

# unimplemented feature

sub speak_to_thief {
    my $message = shift;

    system 'say -v Zarvox "' . $message . '" 2>/dev/null';
}

=head1 DEPENDENCIES

=over 4

=item * Monly::Logger::log_it()

L<Monly::Logger>

=item * Monly::NetStuff::is_up()

L<Monly::NetStuff>

=item * Monly::NetStuff::get_content()

L<Monly::NetStuff>

=back

=head1 AUTHOR

syxanash, C<< <syxanash at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Getter


You can also look for information at:

=over 4

=item * airport

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/airport.8.html>

=item * ipconfig: view and control IP configuration state

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/ipconfig.8.html>

=item * networksetup

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/networksetup.8.html>

=item * imagesnap: take picture form iSight

L<http://iharder.sourceforge.net/current/macosx/imagesnap/>

=item * screencapture: take desktop screenshot

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/screencapture.1.html>

=item * sqlite3

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/sqlite3.1.html>

=item * say: Convert text to audible speech

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/say.1.html>

=back

=cut

1;