#!/usr/bin/perl

# SpireMedia, Inc. Thaddeus Batt thad@spiremedia.com
# Perl script for restarting coldfusion to be called on a scheduled
# basis when frequent and unanticipated restarts of a cf server are required
#
# Please note that there are 2 ways to use this script
# it can be set up as a cgi script that is involked by a web browser
# or it can be run from a cron job directly (this is preferred)
# if the script is used in cgi mode, you will need to use
# the telnet method of restarting cf which means you need to
# enable telnet as well as allow root access via telnet, which
# may be a security risk for which I take no responsibility
# USE THIS CODE AT YOUR OWN RISK
# Date: 10/23/2007

#first lets flush the writes
$|=1;

#bring in the modules we need
use Net::Telnet;
use English;
use HTTP::Headers;
use HTTP::Request;
use LWP::Simple;
use LWP::UserAgent;
use URI::Escape;
use File::Basename;
use POSIX;

$host = 'http://' . GetCgiParam('host');

#you can use this to set up a default hostname
if (! $host) {
$host='http://localhost';
}

$timeout = 30;
$reload = 1;
$url = '/CFIDE/administrator/';
#if restart_on_err is set the function will restart cfmx services and log the error
$restart_on_err = 1;
#this needs to be set to a directory on the machine where you want the log files to live
$path2log = 'c:\\temp\\';
#this is just to see what's going on from command line
print $host.$url;

#and here we go...
$alive = GetCFMXPageOrRestart("$host$url",
$timeout, $user, $pass, $reload);

exit;


sub GetPage {
my ($url, $timeout, $user, $password, $reload) = @_;
my $ua = new LWP::UserAgent;
$ua->use_alarm(1);
$ua->timeout($timeout) if ($timeout);
my $headers = new HTTP::Headers;
$headers->authorization_basic($user, $password);
$headers->header(Pragma => 'no-cache') if $reload;
my $request = new HTTP::Request("GET", $url, $headers);
my $response = $ua->request($request, undef, undef);

($response->is_success,
$response->code,
$response->content,
$response->error_as_HTML);
}

sub GetCFMXPage {
my $url = $_[0];
my ($httpstatus, $httpcode, $httppage, $httperrorHTML) = GetPage(@_);
if ($httppage =~ /TDS stream/) {
open LOG,">>widelog";
print LOG "<<<<<<<<<<<<<<<<\n$url\n>>>>>>>>>>>>>>>>\n";
print LOG $httppage;
close LOG;
$httpstatus = 0;
}
($httpstatus, $httpcode, $httppage, $httperrorHTML);
}

sub GetCFMXPageOrRestart {
my ($httpstatus, $httpcode, $httppage, $httperrorHTML) = GetCFMXPage(@_);
my $url = $_[0];
if ( $restart_on_err ) {
if ($httpcode != 200
|| (!$httpstatus && 200 == $httpcode) ) {
($sec, $min, $hour, $mday, $mon, $year) = localtime;
$mon++;
my $fname = sprintf( "$path2log%2.2d%2.2d%2.2d-%2.2d%2.2d%2.2d.err",
$hour, $min, $sec, $year, $mon, $mday );
open(ERRFILE,">$fname");
print ERRFILE "GetCFMXPage failed at $hour:$min:$sec on $mon/$mday/$year\n";
print ERRFILE "starttime=$starttime\n";
print ERRFILE "reportcount=$reportcount\n";
print ERRFILE "url=$url\n";
print ERRFILE "httpstatus=$httpstatus\n";
print ERRFILE "httpcode=$httpcode\n";
print ERRFILE "httperrorHTML=$httperrorHTML\n";
close(ERRFILE);
print "\nfile=$fname\n";
RestartCFMX();
exit;
#die "Aborted: $fname\n";
}
}
}


sub GetCgiParam {
my ($paramname) = @_;
my ($request_method, $query_string);
if (! %cgiparams) {
$request_method = $ENV{REQUEST_METHOD};
if ($request_method eq 'GET') {
$query_string = $ENV{QUERY_STRING};
}
elsif ($request_method eq 'POST') {
read (STDIN, $query_string, $ENV{CONTENT_LENGTH});
}
elsif ($ARGV[0]) {
$query_string = $ARGV[0];
}
else {
die Usage();
}
foreach $pair (split /&/, $query_string) {
my ($key, $value) = split /=/, $pair;
$value =~ tr/+/ /;
$value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack 'C', hex($1)/eg;
$cgiparams{$key} = $value;
}
}
$cgiparams{$paramname};
}


sub RestartCFMX {

#the following allow this script to run from cgi, note that you will
#be putting the root user password in here if you run it this way
#this is a security risk - if your webserver ever got it's
#mime-type mappings screwed up this pl could be served as plain text
#exposing your root pawword to anyone who can find it
#you should take security measures appropriate to your situation

# $telnet = new Net::Telnet ( Timeout=>30, Errmode=>'die');
# $telnet->open('$host');
# $telnet->waitfor('/login: $/i');
# $telnet->print('root');
# $telnet->waitfor('/password: $/i');
# $telnet->print('password');
# $telnet->waitfor('/# $/i');
# $telnet->print('/opt/coldfusionmx7/bin/coldfusion restart');
# $output = $telnet->waitfor('/# $/i');
# print "Content-Type: text/html\n\n";
# print $output;

#this is safer code if you are able to run this script via
#the root user's crontab
@args_exe = ("/opt/coldfusionmx7/bin/coldfusion","restart");
system(@args_exe) == 0
or die "it didn't work: @args_exe";

print <<HTMLDOC;
<body >
<h1>restarting services</h1>
<PRE>
<p><hr>
</PRE><HR>

HTMLDOC

}



sub Usage {
print <<USAGE;
checkandrestartcfmx.pl host=HOSTNAME
host is hostname to be prepended to script URLs
example: localhost or 216.87.22 or www.code-complete.com
USAGE
}
exit;