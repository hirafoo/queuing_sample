package MyApp::Config;
use parent qw/Exporter/;
use MyApp::Utils;
use YAML::XS ();
use Path::Class ();

our @EXPORT = qw/config/;

my $config_path = Path::Class::file(__FILE__)->dir->subdir('../../')->absolute . "/config.yaml";
my $config = YAML::XS::LoadFile($config_path);
sub config { $config }

1;
