package MyApp::TheSchwartz::Worker;
use parent qw/Class::Accessor::Fast/;
use MyApp::Config;
use MyApp::Utils;
use TheSchwartz;
use UNIVERSAL::require;
use Parallel::Prefork;
use Module::Pluggable::Fast
    require => 1,
    name    => 'components',
    search  => [qw/MyApp::TheSchwartz::Function/];

__PACKAGE__->mk_accessors(qw/option worker/);

my %default_option = (
    max_workers => 10,
    max_requests_per_child => 50,
);

sub new {
    my ($class, $opt) = @_;
    $opt ||= +{};

    my $self = bless {
        option => {
            %default_option,
            %$opt,
        },
        worker => undef,
    }, $class;

    $self->init;
    $self;
}

sub init {
    my ($self, ) = @_;
    $self->init_worker;
}

sub init_worker {
    my ($self, ) = @_;

    my $worker = TheSchwartz->new(databases => config->{theschwartz}->{databases});

    for my $m (__PACKAGE__->components) {
        $m->require;
        say "can_do: $m";
        $worker->can_do($m);
    }

    $self->worker($worker);
}

sub run {
    my ($self, ) = @_;

    my $pm = Parallel::Prefork->new({
        max_workers => $self->option->{max_workers},
        trap_signals => {
            TERM => 'TERM',
            HUP  => 'TERM',
            USR1 => undef,
        },
    });

    while ($pm->signal_received ne 'TERM') {
        $pm->start and next;

        $self->init_worker;
        $self->worker->work;

        $pm->finish;
    }

    $pm->wait_all_children;
}

1;
