package MyApp::Gearman::Worker;
use parent qw/Class::Accessor::Fast/;
use MyApp::Config;
use MyApp::Utils;
use MyApp::Gearman::Function;
use Class::Inspector;
use Gearman::Worker;
use Parallel::Prefork;

__PACKAGE__->mk_accessors(qw/option worker pm/);

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
        pm => undef,
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

    my $worker = Gearman::Worker->new;
    $worker->job_servers(@{config->{gearman}->{servers}});
    $self->worker($worker);

    my $function_class = "MyApp::Gearman::Function";
    my $functions = Class::Inspector->functions($function_class);
    for my $func (grep /^job_/, @$functions) {
        (my $funcname = $func) =~ s/^job_//;
        $self->worker->register_function($funcname => $function_class->can($func));
    }
}


sub run {
    my ($self, ) = @_;

    my $pm = $self->{pm} = Parallel::Prefork->new(
        {
            max_workers  => $self->option->{max_workers},
            trap_signals => {
                TERM => 'TERM',
                HUP  => 'TERM',
                USR1 => undef,
            }
        }
    );

    while ($pm->signal_received ne 'TERM') {
        $pm->start and next;
        $self->worker->work;
        $pm->finish;
    }

    $pm->wait_all_children();
}

1;
