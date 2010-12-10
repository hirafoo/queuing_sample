package MyApp::TheSchwartz::Function;
use parent qw/TheSchwartz::Worker/;
use MyApp::Utils;

sub work {
    my ($class) = shift;
    my TheSchwartz::Job $job = shift;

    p [$class, $job];

    $class->do_work($job->arg);
    $job->completed;
}

1;
