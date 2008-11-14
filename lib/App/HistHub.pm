package App::HistHub;
use utf8;
use Moose;

use POE qw/
    Wheel::FollowTail
    Component::Client::HTTPDeferred
    /;

use JSON::XS ();
use HTTP::Request::Common;
use Fcntl ':flock';

our $VERSION = '0.01';

has hist_file => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has tailor => (
    is  => 'rw',
    isa => 'POE::Wheel::FollowTail',
);

has ua => (
    is      => 'rw',
    isa     => 'POE::Component::Client::HTTPDeferred',
    lazy    => 1,
    default => sub {
        POE::Component::Client::HTTPDeferred->new;
    },
);

has json_driver => (
    is      => 'rw',
    isa     => 'JSON::XS',
    lazy    => 1,
    default => sub {
        JSON::XS->new;
    },
);

has poll_delay => (
    is      => 'rw',
    isa     => 'Int',
    default => sub { 5 },
);

has update_queue => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
);

has api_endpoint => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has api_uid => (
    is  => 'rw',
    isa => 'Str',
);

sub spawn {
    my $self = shift;

    POE::Session->create(
        object_states => [
            $self => {
                map { $_ => "poe_$_" } qw/_start init poll set_poll hist_line hist_rollover/
            },
        ],
    );
}

sub run {
    my $self = shift;
    $self->spawn;
    POE::Kernel->run;
}

sub poe__start {
    my ($self, $kernel, $session) = @_[OBJECT, KERNEL, SESSION];

    my $d = $self->ua->request( GET $self->api_endpoint . '/api/init' );
    $d->addCallback(sub {
        my $res = shift;
        my $json = $self->json_driver->decode($res->content);

        if ($json->{error}) {
            die 'api response error: ' . $json->{error};
        }
        else {
            $self->api_uid( $json->{result}{uid} );
            $kernel->post( $session->ID, 'init' );
        }
    });
    $d->addErrback(sub {
        my $res = shift;
        die 'api response error: ', $res->status_line;
    });
}

sub poe_init {
    my ($self, $kernel) = @_[OBJECT, KERNEL];

    my $tailor = POE::Wheel::FollowTail->new(
        Filename   => $self->hist_file,
        InputEvent => 'hist_line',
        ResetEvent => 'hist_rollover',
    );
    $self->tailor( $tailor );

    $kernel->yield('set_poll');
}

sub poe_hist_line {
    my ($self, $kernel, $line) = @_[OBJECT, KERNEL, ARG0];

    push @{ $self->update_queue }, $line;
    $kernel->yield('set_poll');
}

sub poe_hist_rollover {
    my ($self, $kernel) = @_[OBJECT, KERNEL];
    
}

sub poe_set_poll {
    my ($self, $kernel) = @_[OBJECT, KERNEL];
    $kernel->delay( poll => $self->poll_delay );
}

sub poe_poll {
    my ($self, $kernel, $session) = @_[OBJECT, KERNEL, SESSION];

    warn 'poll';
    $kernel->yield('set_poll');

    my $d = $self->ua->request(
        POST $self->uri_for('/api/poll'),
        [ uid => $self->api_uid, data => join '', @{ $self->update_queue } ]
    );
    $self->update_queue([]);

    $d->addCallback(sub { $self->append_history(shift->content) });
    $d->addErrback(sub { warn 'api poll error: ' . shift->status_line });
    $d->addBoth(sub { $kernel->post($session->ID => 'set_poll') });
}

sub uri_for {
    my ($self, $path) = @_;

    (my $url = $self->api_endpoint) =~ s!/+$!!;
    $url . $path;
}

sub append_history {
    my ($self, $data) = @_;

    warn 'polled';

    my $json = $self->json_driver->decode($data);
    if ($json->{error}) {
        warn 'api poll error: '. $json->{error};
    }
    elsif ($json->{result}) {
        warn 'append_history';
        warn $json->{result};
        open my $fh, '>>', $self->hist_file;

        flock($fh, LOCK_EX);
        seek($fh, 0, 2);

        print $fh $json->{result};

        flock($fh, LOCK_UN);
        close $fh;
    }
}

=head1 NAME

App::HistHub - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

  use App::HistHub;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
