package Monly::NetStuff;
use strict;
use warnings;

use LWP::Simple qw{ get };
use LWP::UserAgent;

=head1 NAME

Monly::NetStuff - Make things with LWP

=head1 DESCRIPTION

This module contains various subroutines for
networking features.

=cut

use base 'Exporter';

our @EXPORT_OK = qw{ is_up };
our @EXPORT    = qw{
  check_connection
  get_content
  is_stolen };

=head1 SYNOPSIS

    use Monly::NetStuff;

    # check in internet connection is available

    if ( check_connection() ) {
        # get html content of a specified web page

        $google_homepage = get_content('http://www.google.com');
    }

    # check remotely if Monly should be enabled

    if ( is_stolen(http://mysite.com/monly_status/) ) {
        # I'm going to do stuff because my macbook has been stolen
    }

    # check if a given website is reachable

    if ( is_up('http://www.google.com') ) {
        print "up and running sir! \n";
    }
    else {
        print "oh dear god this is the apocalypse\n";
    }

=head1 EXPORT

=over 4

=item * check_connection: check your internet connection

=item * get_content: get content of a specified webpage

=item * is_stolen: do things if page returns enabled

=back

=head1 SUBROUTINES/METHODS

=head2 check_connection

Check between a list of common websites
if all of them are not reachable, you're most likely
offline.

=cut

sub check_connection {
    my @websites = (
        "http://www.google.com",
        "http://www.facebook.com",
        "http://www.twitter.com",
    );

    my $am_i_on = 0;

    foreach my $site (@websites) {
        if ( is_up($site) ) {
            $am_i_on = 1;
            last;
        }
    }

    return $am_i_on;
}

=head2 get_content

Gets the content from a given website.
Returns false if connection goes down.

=cut

sub get_content {
    my $website = shift;
    my ( $lwp_useragent, $lwp_response, $lwp_content );

    $lwp_useragent = LWP::UserAgent->new;
    $lwp_useragent->agent('Monly Tracker');

    $lwp_response = $lwp_useragent->get($website);

    if ( $lwp_response->is_success ) {
        $lwp_content = $lwp_response->content;
    }

    return $lwp_content;
}

=head2 is_stolen

Check a specified webpage. If the content
has the keyword "enabled" then function returns
true otherwise returns false. 

=cut

sub is_stolen {
    my $website_address = shift;
    my $final_status    = 0;

    if ( is_up($website_address) ) {
        if ( get_content($website_address) =~ m< enabled >xms ) {
            $final_status = 1;
        }
    }

    return $final_status;
}

=head2 is_up

Check if a given websites is available using LWP::Simple::Get()

=cut

sub is_up {
    my $website = shift;
    my $is_up   = 1;

    $is_up = 0
      if ( !get($website) );

    return $is_up;
}

=head1 DEPENDENCIES

No internal packages required.

=head1 AUTHOR

syxanash, C<< <syxanash at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc NetStuff


You can also look for information at:

=over 4

=item * LWP::Simple

L<LWP::Simple>

=item * LWP::UserAgent

L<LWP::UserAgent>

=back

=cut

1;