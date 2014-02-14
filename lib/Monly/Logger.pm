package Monly::Logger;
use strict;
use warnings;

use POSIX qw(strftime);

=head1 NAME

Monly::Logger - Log things

=head1 DESCRIPTION

Make a log file everytime Monly is executed.

=cut

use base 'Exporter';

our @EXPORT_OK = qw{};
our @EXPORT    = qw{
  new_log
  log_it };

=head1 SYNOPSIS

    use Monly::Logger;
    
    # NEVER FORGET TO CREATE A NEW LOG
    new_log();

    log_it("Hi mom!\n");

    # log file will contain
    # Mer Feb 12 13:30:00 2014 - Hi mom!

=head1 EXPORT

=over 4

=item * new_log: create a new log in /tmp/

=item * log_it: write your messages inside current log file

=back

=cut

my $log_name = '/tmp/' . time() . '_monly.log';

=head1 SUBROUTINES/METHODS

=head2 new_log

Create a new log where to store messages.

=cut

sub new_log {
    open my $FILEHANDLE, '>', $log_name
      or log_it("[!] log file wasn't created: $!\n");

    print {$FILEHANDLE} q{};

    close $FILEHANDLE;
}

=head2 log_it

Using strftime() write (inside current log file) the
message given as argument. Add date of execution
right next to the message.

=cut

sub log_it {
    my $message = shift;
    my $time = strftime '%a %b %e %H:%M:%S %Y', localtime;

    open my $FILEHANDLE, '>>', $log_name
      or log_it("[!] can't open log file in append: $!\n");

    print {$FILEHANDLE} $time, ' - ', $message;

    close $FILEHANDLE;
}

=head1 DEPENDENCIES

No internal packages required.

=head1 AUTHOR

syxanash, C<< <syxanash at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<syxanash at gmail.com>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Logger


You can also look for information at:

=over 4

=item * POSIX

L<http://perldoc.perl.org/POSIX.html>

=back

=cut

1;