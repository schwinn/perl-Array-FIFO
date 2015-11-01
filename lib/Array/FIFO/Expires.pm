package Array::FIFO::Expires;

use Moose;

extends 'Array::FIFO';

use Array::FIFO::Data;

has '+queue' => ( isa => 'ArrayRef[Array::FIFO]' );

around add => sub {
    my $orig = shift;
    my $self = shift;

    my $last = $self->$orig( @_ );

    $last->value;
};


sub _build_sum {
    my $self = shift;

    my $size = $self->size;

    sum0( grep /^-?\d+\.?\d*$/, map { $_->value } @{ $self->queue } );
}


1;

