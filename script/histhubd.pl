#!/usr/bin/env perl

use strict;
use warnings;

use FindBin::libs;
use Pod::Usage;
use Getopt::Long;

use App::HistHub;

my $hh = App::HistHub->new(
    hist_file    => '/Users/typester/.zhistory',
    api_endpoint => 'http://localhost:3000/',
);
$hh->run;

