package Monly;
use strict;
use warnings;

our $VERSION = 0.01;

1;

__END__

=pod

=head1 NAME

Monly - The brand new Anti-thief tracker you can trust (I think)

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

Monly is a script which tracks your computer, if is stolen, sending in
your email box various information about geolocation, webcam photos,
desktop screenshots, history downloads and wifi access points name in range.

=head1 CONFIGURATION AND ENVIRONMENT

To properly use Mac OS X Airport tool you can create a link to airport
and place it in /usr/sbin/, type the following command in your Terminal:

  sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport

You'll need the tool imagesnap in order to take photos from iSight device.
Once you've downloaded imagesnap, place it in /usr/local/bin/
You can get imagesnap from here:

L<http://iharder.sourceforge.net/current/macosx/imagesnap/>

=head1 DEPENDENCIES

Here's a list of all Perl modules you'll have to install
if you want to use Monly.

=over 4

=item * IPC::System::Simple

L<https://metacpan.org/pod/IPC::System::Simple>

=item * Email::Send::SMTP::Gmail

L<https://metacpan.org/pod/Email::Send::SMTP::Gmail>

=item * JSON

L<https://metacpan.org/pod/JSON>

=item * LWP::Simple

L<https://metacpan.org/pod/LWP::Simple>

=item * LWP::UserAgent

L<https://metacpan.org/pod/LWP::UserAgent>

=item * POSIX

L<https://metacpan.org/pod/POSIX>

=back

=head1 AUTHOR

syxanash, C<< <syxanash at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Monly

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 syxanash.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. Do what you want cause a pirate is FREE.

=cut