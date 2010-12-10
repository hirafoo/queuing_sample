use lib "lib";
use MyApp::Utils;
use MyApp::TheSchwartz::Client;
use Getopt::Long;

my %args;
GetOptions(\%args, qw/Foo Bar/);

my $client = MyApp::TheSchwartz::Client->new();

if ($args{Foo}) {
    $client->enqueue(Foo => {str => "call foo!"});
}
elsif ($args{Bar}) {
    $client->enqueue(Bar => {str => "BAAAAAAAAAAAAAAAAAAR !!"});
}
