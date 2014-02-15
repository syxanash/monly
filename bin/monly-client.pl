#!/usr/bin/env perl

use strict;
use warnings;

use JSON;
use Getopt::Long;
use Pod::Usage;
use version;
use File::Slurp;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Monly;
use Monly::EmailSender;
use Monly::Getter;
use Monly::Airport;
use Monly::NetStuff;
use Monly::Logger;

our $VERSION = qv('0.0.1');

my $EMPTY = q{};

my %actions = (
    read    => $EMPTY,
    delay   => $EMPTY,
    remote  => $EMPTY,
    version => $EMPTY,
    help    => $EMPTY,
);

# getting argv parameters

GetOptions(
    'read=s'   => \$actions{read},
    'delay=i'  => \$actions{delay},
    'remote=s' => \$actions{remote},
    'version'  => \$actions{version},
    'help'     => \$actions{help},
);

my $delay_seconds     = $EMPTY;
my $file_content      = $EMPTY;
my $config_file       = $EMPTY;
my $remote_web_server = $EMPTY;

my $first_execution = 1;

# parse argv parameters

if ( $actions{help} ) {
    pod2usage(1);
}

# show version number of client

die "Version: $VERSION\n"
  if ( $actions{version} );

# set delay seconds between checks

if ( $actions{delay} ) {
    $delay_seconds = $actions{delay};
}

# specify a website which contains Monly status

if ( $actions{remote} ) {
    $remote_web_server = $actions{remote};
}

# read json content for gmail configuration, site where
# to read the status of Monly and delay seconds

if ( $actions{read} ) {
    $file_content = read_file( $actions{read} );
    $config_file  = decode_json( $file_content );

    die "[!] Please write a valid JSON configuration for Monly!\n"
      unless ( check_configuration($config_file) );

    if ( !$remote_web_server ) {
        $remote_web_server = $config_file->{'website'};
    }

    if ( !$delay_seconds ) {
        $delay_seconds = $config_file->{'delay'};
    }
}
else {
    die "[!] Please specify a valid JSON configuration file!\n";
}

# create a new log file

new_log();

while (1) {
    if ( $first_execution ) {
        # wait a few seconds just to make sure
        # connection is ready after boot

        sleep( int( rand(20) ) + 10 );

        $first_execution = 0;
    }

    if ( check_connection() ) {

        # check remotely if Monly is enabled
        if ( is_stolen($remote_web_server) ) {
            my $info_location = get_info();
            my $device_info   = get_local_info();

            my $picture_path = get_picture();
            my $desktop_pic  = get_desktop();

            my $history_download = get_history_download();

            send_email(
                $config_file->{'username'}, $config_file->{'password'},
                $info_location,             $device_info,
                $picture_path,              $desktop_pic,
                $history_download,
            );
        }
        else {
            log_it("[?] Monly is currently disabled!\n");
        }
    }
    elsif ( airport_status() eq 'Off' ) {
        toggle_airport();

        # once aiport was set to On mode
        # check again wifi connection

        next;
    }
    else {
        toggle_airport();    # turn wifi on if not enabled
        log_it("[?] Connection seems to be down, but trying to look for open wifi networks...\n");
        try_connection();
    }

    sleep $delay_seconds;
}

# check if JSON configuration file has all the
# field required in order to properly run

sub check_configuration {
    my $json_file_configuration = shift;

    my $is_valid       = 1;
    my $field_found    = 0;
    my @field_required = ( 'username', 'password', 'website', 'delay', );

    foreach my $keys ( keys %{$json_file_configuration} ) {
        foreach my $field (@field_required) {
            if ( $keys eq $field ) {
                $field_found++;
            }
        }
    }

    if ( $field_found < scalar(@field_required) ) {
        $is_valid = 0;
    }

    return $is_valid;
}

__END__

=pod

=head1 NAME

monly-client.pl - The brand new Anti-thief tracker you can trust (I think)

=head1 SYNOPSIS

perl monly-client.pl [--options] <parameters>

 General Options:
  --read=CONFIG FILE    JSON configuration file with gmail credentials
  --delay=SECONDS       Set a custom delay between checks
  --remote=MYWEBSITE    Specify the path of the configuration file to read
  --version             Show current client version
  --help                Show this fabulous help of course!

=head1 REQUIRED ARGUMENTS

 --read=CONFIG FILE

=head1 DESCRIPTION

maybe one day you'll see a description here...

=head1 DEPENDENCIES

JSON ~ http://search.cpan.org/~makamaka/JSON-2.59/lib/JSON.pm

Getopt::Long ~ http://search.cpan.org/~enrys/POD2-IT-Getopt-Long/lib/POD2/IT/Getopt/Long.pm

File::Slurp ~ http://search.cpan.org/~uri/File-Slurp-9999.19/lib/File/Slurp.pm

version ~ http://search.cpan.org/~jpeacock/version-0.99/lib/version.pod

Pod::Usage ~ http://perldoc.perl.org/Pod/Usage.html

=head1 SEE ALSO

Getopt::Long and Pod::Usage http://perldoc.perl.org/Getopt/Long.html#Documentation-and-help-texts

=head1 LICENSE AND COPYRIGHT

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.
 
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. Do what you want cause a pirate is FREE.

=head1 AUTHOR

@syxanash

=cut