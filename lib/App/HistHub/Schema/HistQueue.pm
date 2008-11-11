package App::HistHub::Schema::HistQueue;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("ResultSetManager", "UTF8Columns", "Core");
__PACKAGE__->table("hist_queue");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "timestamp",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "body",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2008-11-11 18:43:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5ZAXcjnMpnNO9E6JWdGVyA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
