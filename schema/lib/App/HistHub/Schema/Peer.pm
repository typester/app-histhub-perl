package App::HistHub::Schema::Peer;
use strict;
use warnings;

use DateTime;
use Data::UUID;
use Digest::SHA1 qw/sha1_hex/;

__PACKAGE__->has_many( queue => 'App::HistHub::Schema::HistQueue', 'peer' );

__PACKAGE__->inflate_column(
    access_time => {
        inflate => sub { DateTime->from_epoch( epoch => shift ) },
        deflate => sub { shift->epoch },
    },
);

sub insert {
    my $self = shift;
    $self->uid( sha1_hex( Data::UUID->new->create ) );
    $self->access_time( DateTime->now ) unless $self->access_time;
    $self->next::method(@_);
}

1;
