package App::HistHub::Schema::HistQueue;
use strict;
use warnings;

use DateTime;

__PACKAGE__->utf8_columns(qw/data/);

__PACKAGE__->belongs_to( peer => 'App::HistHub::Schema::Peer' );

__PACKAGE__->inflate_column(
    timestamp => {
        inflate => sub { DateTime->from_epoch( epoch => shift ) },
        deflate => sub { shift->epoch },
    },
);

sub insert {
    my $self = shift;
    $self->timestamp( DateTime->now ) unless $self->timestamp;
    $self->next::method(@_);
}

1;

