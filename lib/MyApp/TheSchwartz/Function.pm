package MyApp::TheSchwartz::Function;
use parent qw/TheSchwartz::Worker/;
use MyApp::Utils;

sub work {
    my ($class) = shift;
    my TheSchwartz::Job $job = shift;

    say "work begin: $class";
    $class->do_work($job->arg);
    $job->completed;
    say "work end: $class";
}

1;
