package Monly::EmailSender;
use strict;
use warnings;

# Logger is required to write info in log file
use Monly::Logger qw{ log_it };

use Email::Send::SMTP::Gmail;

=head1 NAME

Monly::EmailSender - Email sender

=head1 DESCRIPTION

Sends emails in html format to a specified
gmail account, via Email::Send::SMTP::Gmail.

=cut

use base 'Exporter';

our @EXPORT_OK = qw{ zip_it };
our @EXPORT    = qw{ send_email };

=head1 SYNOPSIS

    use Monly::EmailSender;

    send_email(
        $gmail_credentials->{'username'},
        $gmail_credentials->{'password'},
        $info_location,
        $device_info,
        $picture_path,
        $desktop_pic,
        $history_download,
    );

=head1 EXPORT

=over 4

=item * send_email: send email to a specified gmail account

=back

=head1 SUBROUTINES/METHODS

=head2 send_email

Arguments:

=over 4

=item * username: gmail account name

=item * password: gmail account password

=item * info_location: geolocaton info

=item * device_info: various information about mac os x wifi device

=item * picture_path: path to a picture taken with imagesnap

=item * desktop_pic: screenshot of your desktop taken with screencapture

=item * history_download: history download file

=back

Send (html formatted) email to a configured GMAIL
account containing various information.

=cut

sub send_email {
    my $username = shift;
    my $password = shift;

    my $info_location = shift;
    my $device_info   = shift;

    my $picture_path = shift;
    my $desktop_pic  = shift;

    my $history_download = shift;

    my $archive_name = zip_it( $picture_path, $desktop_pic, $history_download );

    # convert carriage return into <br> html tag

    $info_location =~ s/\n/<br>/g;
    $device_info =~ s/\n/<br>/g;

    my $message = <<"END_MESSAGE";
Il tuo computer <b>e' stato tracciato</b> sotto le seguenti informazioni:<br><br>

$info_location<br>
<b>Atre informazioni</b> sulla macchina:<br>

<pre>$device_info</pre>
In allegato troverete un <b>archivio zip</b> con altre informazioni prese dal computer
END_MESSAGE

    my $mail = Email::Send::SMTP::Gmail->new(
        -smtp  => 'smtp.gmail.com',
        -login => $username,
        -pass  => $password,

        # -debug => 1,
        -layer => 'ssl',
    );

    $mail->send(
        -to          => $username,
        -subject     => 'Anti-thief WARNING',
        -body        => $message,
        -contenttype => 'text/html',
        -attachments => "$archive_name",
    );

    $mail->bye;

    # remove zip file just uploaded

    if ( -e $archive_name ) {
        unlink $archive_name;
    }

    log_it("[*] Email successfully sent!\n");
}

=head2 zip_it

Create a zip archive of all files taken as arguments.
Return the name of the zip archive created after removing the files.

=cut

sub zip_it {
    my $files_line = join ' ', @_;
    my $zip_name = '/tmp/' . time() . '_info.zip';

    system '/usr/bin/zip ' . $zip_name . ' ' . $files_line . ' &> /dev/null';

    # files just zipped

    foreach (@_) {
        unlink $_
          if ( -e $_ );
    }

    log_it("[!] Zip archive was not created!\n")
      unless ( -e $zip_name );

    return $zip_name;
}

=head1 DEPENDENCIES

Monly::Logger::log_it()

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

    perldoc EmailSender


You can also look for information at:

=over 4

=item * zip: package and compress (archive) files

L<https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/zip.1.html>

=item * Email::Send::SMTP::Gmail

L<Email::Send::SMTP::Gmail>

=back

=cut

1;