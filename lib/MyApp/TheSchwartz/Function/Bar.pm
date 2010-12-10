package MyApp::TheSchwartz::Function::Bar;
use parent qw/MyApp::TheSchwartz::Function/;
use MyApp::Utils;

sub do_work {
    my ($class, $args) = @_;
    
    my $str = $args->{str} || "no args, bar";

    my $out_path = app_home . "/theschwartz_result";
    open my $fh, ">>", $out_path or die $@;
    $fh->print(time . " work BAR, str: $str\n");
    close $fh;
}

1;
