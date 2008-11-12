package App::HistHub::Web::Controller::API;
use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->mk_accessors(qw/result error/);

use Data::UUID;
use Digest::SHA1 qw/sha1_hex/;

=head1 NAME

App::HistHub::Web::Controller::API - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 init

=cut

sub init :Local :Args(0) {
    my ($self, $c) = @_;

    my $peer = $c->model('DB::Peer')->create({});
    $self->result({ uid => $peer->uid });
}

=head2 end

=cut

sub end :Private {
    my ($self, $c) = @_;

    if (@{ $c->error }) {
        (my $last_error = $c->error->[-1]) =~ s/ on .*?$//;

        $c->res->status(500);
        $c->stash->{json} = {
            error => $last_error,
        };
        $c->error(0);
    }
    elsif ($self->result or $self->error) {
        $c->stash->{json} = {
            result => $self->result || '',
            error  => $self->error || '',
        };
    }

    $c->forward( $c->view('JSON') );
}

=head1 AUTHOR

Daisuke Murase

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
