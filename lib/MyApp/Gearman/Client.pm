package MyApp::Gearman::Client;
use parent qw/Class::Accessor::Fast/;
use MyApp::Config;
use MyApp::Utils;
use Gearman::Client;

__PACKAGE__->mk_accessors(qw/client/);

sub new {
    my ($class, $opt) = @_;
    
    my $client = Gearman::Client->new;
    $client->job_servers(@{config->{gearman}->{servers}});

    bless {
        client => $client,
    }, $class;
}

sub do_realtime {
    my ($self, $funcname, $args) = @_;

    $args ||= +{};
    my $funcargs = serialize($args);
    my $d = deserialize($funcargs);
    say "do realtime, func:$funcname";
    my $result = $self->client->do_task($funcname => $funcargs);
    return $result;
}

sub do_later {
    my ($self, $funcname, $args) = @_;

    $args ||= +{};
    my $funcargs = serialize($args);
    say "do later, func:$funcname";
    my $result = $self->client->dispatch_background($funcname => $funcargs);
    return $result;
}

sub do_realtime_many {
    my ($self, $funcname, $args) = @_;

    $args ||= +{};
    my $result = [];
    my $taskset = $self->client->new_task_set;

    for my $i (1..10) {
        $args->{loop_time} = $args->{sleeping} = $i;
        my $funcargs = serialize($args);

        $taskset->add_task($funcname => $funcargs, {
                on_complete => sub {
                    my $job_result = shift;
                    if (ref $job_result && ref $job_result eq 'SCALAR') {
                        $job_result = $$job_result;
                    }
                    push @$result, deserialize($job_result);
                },
                on_fail => sub {
                    my $meth = "fail_$funcname";
                    if (my $fail_func_ref = MyApp::Gearman::Function->can($meth)) {
                        my $fail_result = $fail_func_ref->($funcargs);
                        push @$result, $fail_result;
                    }
                },
                timeout => 15,
            }
        );
    }

    $taskset->wait;
    return $result;
}

1;
