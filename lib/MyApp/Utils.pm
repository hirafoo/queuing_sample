package MyApp::Utils;
use strict;
use warnings;
use parent qw/Exporter/;
use Data::Dumper qw/Dumper/;
use Storable ();
use Path::Class ();

our @EXPORT = qw/p say app_home serialize deserialize irand/;

sub import {
    strict->import;
    warnings->import;
    __PACKAGE__->export_to_level(1, @_);
}

sub p {
    warn Dumper @_;
    my @c = caller;
    print STDERR "  at $c[1]:$c[2]\n\n";
}

sub say {
    print @_, "\n";
}

sub serialize {
    my $datum = shift;
    if (ref $datum) {
        my $result = eval { Storable::nfreeze($datum) };
        return $result;
    }
    else {
        #my @c = caller;
        #p \@c;
        warn "no need to serialize";
        return $datum;
    }
}

sub deserialize {
    my $datum = shift;
    if (ref $datum) {
        #my @c = caller;
        #p \@c;
        warn "not serialized data";
        return $datum;
    }
    else {
        my $result = eval { Storable::thaw($datum) };
        return $result;
    }
}

my $app_home = Path::Class::file(__FILE__)->dir->subdir('../../')->absolute;
sub app_home { $app_home }

sub irand {
    my $r = shift || 10;
    int(rand($r)) + 1;
}

1;
