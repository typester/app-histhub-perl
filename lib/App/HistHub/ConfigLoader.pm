package App::HistHub::ConfigLoader;
use strict;
use warnings;

use FindBin::libs qw/export/;
use File::HomeDir;
use YAML;

sub load {
    my @files;
    my $base = (@App::HistHub::ConfigLoader::lib)[0];
    if ($base) {
        push @files, "$base/config.yaml";
        push @files, "$base/config_local.yaml";
    }
    push @files, File::HomeDir->my_home . '/.histhub';

    my $conf = {};
    for my $file (@files) {
        next unless -f $file && -s _ && -r _;
        my $c = YAML::LoadFile($file);
        for my $k (keys %$c) {
            $conf->{$k} = $c->{$k};
        }
    }

    $conf;
}

1;

