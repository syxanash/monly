##Monly Tracker

![Monly Logo](http://i.imgur.com/kWO9fJT.png "Monly Logo")

### The brand new Anti-thief tracker you can trust (I think)

**Monly Tracker** is an old project I developed back in 2010 and I strongly wanted to keep working on. For the moment it  was only tested on Mac OS X Lion 10.7.5

##Synopsis

```
perl monly-client.pl [--options] <parameters>

 General Options:
  --read=CONFIG FILE    JSON configuration file with gmail credentials
  --delay=SECONDS       Set a custom delay between checks
  --remote=MYWEBSITE    Specify the path of the configuration file to read
  --version             Show current client version
  --help                Show this fabulous help of course!
```

##Description

maybe one day you'll see a description here, but for now just read the POD!

##JSON configuration

here's an example of how you should write a valid JSON configuration file for Monly.

```json
{
    "username": "chandler_bing@gmail.com",
    "password": "SongvEtel188",
    "delay": "120",
    "website": "http://mywebsite.com/monly_status/"
}
```

##Installation

This script requires the tools **airport** and **imagesnap**.
To properly use Mac OS X Airport tool you can create a link to airport
and place it in /usr/sbin/, type the following command in your Terminal:

```sh
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport
```

You'll also need the tool imagesnap in order to take photos from iSight device.
Once you've downloaded imagesnap, place it in /usr/local/bin/
You can get imagesnap from [here](http://iharder.sourceforge.net/current/macosx/imagesnap/).

You also need various Perl modules to make this script work, here's the list:

* [IPC::System::Simple](https://metacpan.org/pod/IPC::System::Simple)
* [Email::Send::SMTP::Gmail](https://metacpan.org/pod/Email::Send::SMTP::Gmail)
* [JSON](http://search.cpan.org/~makamaka/JSON-2.59/lib/JSON.pm)
* [LWP::UserAgent](http://search.cpan.org/~gaas/libwww-perl-6.04/lib/LWP/UserAgent.pm)
* [LWP::Simple](https://metacpan.org/pod/LWP::Simple)
* [POSIX](https://metacpan.org/pod/POSIX)
* [Getopt::Long](http://search.cpan.org/~enrys/POD2-IT-Getopt-Long/lib/POD2/IT/Getopt/Long.pm)
* [File::Slurp](http://search.cpan.org/~uri/File-Slurp-9999.19/lib/File/Slurp.pm)
* [Pod::Usage](http://perldoc.perl.org/Pod/Usage.html)
* [version](http://search.cpan.org/~jpeacock/version-0.99/lib/version.pod)

After installing all required modules, type the command:

```sh
make install
```

and Monly will be automatically copied into /usr/local/bin/monly

##License
### Monly is released under the DWTFYWT:

```
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.
 
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. Do what you want cause a pirate is FREE.
```

##About

This script was developed by [@syxanash](http://twitter.com/syxanash), if you have any kind of suggestions, criticisms, or bug fixes please let me know :-)