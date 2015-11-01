package Array::FIFO::Data;

use Moose;

has value => ( is => 'rw', isa => 'Item' );
has expires_at => ( is => 'rw', isa => 'Num' );

1;

