use lib "lib";
use MyApp::Utils;
use MyApp::Gearman::Client;
use Getopt::Long;

my %args;
GetOptions(\%args, qw/realtime later realtime_many/);

my $client = MyApp::Gearman::Client->new;

if ($args{realtime}) {
    $client->do_realtime(foo => +{sleeping => irand()});
}
elsif ($args{later}) {
    $client->do_later(foo => +{sleeping => irand()});
}
elsif ($args{realtime_many}) {
    $client->do_realtime_many("foo");
}
