package MyApp::TheSchwartz::Client;
use parent qw/Class::Accessor::Fast/;
use MyApp::Config;
use MyApp::Utils;
use TheSchwartz;
use UNIVERSAL::require;
use Parallel::Prefork;
use Module::Pluggable::Fast
    search => [qw/MyApp::TheSchwartz::Worker/];

__PACKAGE__->mk_accessors(qw/client/);

sub new {
    my ($class, $opt) = @_;
    #p @{config->{theschwartz}->{databases}->[0]}{qw/dsn user pass/};
    my $client = TheSchwartz->new(databases => config->{theschwartz}->{databases});
    bless {
        client => $client,
    }, $class;
}

sub enqueue {
    my ($self, $classname, $args) = @_;
    $args ||= +{};
    p [$classname, $args];
    if ($classname !~ /^MyApp::TheSchwartz::Function/) {
        $classname = "MyApp::TheSchwartz::Function::$classname";
    }

    $self->client->insert($classname => $args);
}

1;
