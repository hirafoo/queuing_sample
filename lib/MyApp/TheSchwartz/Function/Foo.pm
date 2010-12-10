package MyApp::TheSchwartz::Function::Foo;
use parent qw/MyApp::TheSchwartz::Function/;
use MyApp::Utils;

sub do_work {
    my ($class, $args) = @_;
    p "sleep worker";
    
    my $out_path = app_home . "/theschwartz_foo_result";
    open my $fh, ">>", $out_path or die $@;
    $fh->print("Workin' hard or hardly workin'? Hyuk!!\n");
    close $fh;
}

1;
