package Array::FIFO::Data;

use Moose;
use AnyEvent;

has value => ( is => 'rw', isa => 'Item' );
has expires => ( is => 'rw', isa => 'Int' );
has timer => (
    is => 'rw',
    isa => 
    );

sub BUILD {
    my ($self) = @_;

    if ($self->expires > 0) {
        $self->timer( 
            AnyEvent->timer(
                after => $self->expires,
                cb => sub {
                    print "expired $self\n";
                    ; # yank from queue
                }
                );
            );
    }

}


1;

