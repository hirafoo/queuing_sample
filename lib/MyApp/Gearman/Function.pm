package MyApp::Gearman::Function;
use MyApp::Config;
use MyApp::Utils;
use Class::Inspector;

sub job_foo {
    my $job = shift;
    my $args = $job->arg;
    my $funcargs = deserialize($args);
    my $sleeping = $funcargs->{sleeping} || irand() + 1;

    my $out_path = app_home . "/gearman_foo_result";
    open my $fh, ">>", $out_path or die $@;

    my $t1 = time;
    say "sleep $sleeping";
    sleep $sleeping;
    my $t2 = time;

    my $result = "before_after: $t1, $t2";
    if (my $loop_time = $funcargs->{loop_time}) {
        $result .= " loop_time: $loop_time";
    }
    $result .= "\n";

    $fh->print($result);
    
    close $fh;

    return $result;
}

sub fail_foo {
    my ($class, $funcargs) = @_;
    p "job foo failed";
    return;
}

1;
