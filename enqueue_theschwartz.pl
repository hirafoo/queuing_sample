use lib "lib";
use MyApp::Utils;
use MyApp::TheSchwartz::Client;
use Getopt::Long;

my %args;
GetOptions(\%args, qw/Sleep Foo/);

my $client = MyApp::TheSchwartz::Client->new();

if ($args{Sleep}) {
    $client->enqueue("Sleep");
}
elsif ($args{Foo}) {
    $client->enqueue("Foo");
}
