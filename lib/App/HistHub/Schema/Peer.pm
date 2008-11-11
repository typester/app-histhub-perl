package App::HistHub::Schema::Peer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("ResultSetManager", "UTF8Columns", "Core");
__PACKAGE__->table("peer");
__PACKAGE__->add_columns(
  "uid",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "created",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "cursor",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("uid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-11-11 18:43:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nAs+kqn9Ca58vSO7Fk022g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
