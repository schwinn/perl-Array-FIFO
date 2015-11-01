package Array::FIFO::Expires;

use Moose;

extends 'Array::FIFO';

use Array::FIFO::Data;

has '+queue' => ( isa => 'ArrayRef[Array::FIFO]' );

has expires => ( is => 'rw', isa => 'Int', default => 0 );

around add => sub {
    my ($orig, $self, $value, $expires) = @_;

    $expires //= $self->expires;

    my $data = Array::FIFO::Data->new( value => $value, expires => $expires, array => $self );
    my $w = AnyEvent->timer( after => $seconds, interval => $seconds,  );

    my $last = $self->$orig( $data );

    $last->value;
};


sub _build_sum {
    my $self = shift;

    my $size = $self->size;

    sum0( grep /^-?\d+\.?\d*$/, map { $_->value } @{ $self->queue } );
}


1;

