package Array::FIFO;

use Moose;




has max_size => ( is => 'rw', isa => 'Int', default => -1 );
has size => ( is => 'rw', isa => 'Int', default => 0 );

has queue => (
    is => 'rw',
    isa => 'ArrayRef[Item]', 
    traits => [ 'Array' ],
    default => sub { [ ] },
    handles => {
        add => 'push',
        remove => 'shift'
    },
    trigger => sub {
        my $self = shift;

        my $array = $self->{queue};
        while (@{ $array } > $self->{max_size}) {
            shift @{ $array };
        }

        $self->size( scalar @{ $self->queue } );

        my $sum = 0;
        foreach my $q (@{ $self->queue }) {
            #if (($q =~ /^-?\d+$/) || ($q =~ /^-?\d+\.?\d*$/)) {
            if ($q =~ /^-?\d+\.?\d*$/) {
                $sum += int($q);
            }
        }

        $self->sum( $sum );
        if ($sum > 0) {
            $self->average( $sum / $self->size );
        }
        else {
            $self->average(0);
        }
    },
    );

has sum => ( is => 'rw', isa => 'Int' );
has average => ( is => 'rw', isa => 'Num' );


__PACKAGE__->meta->make_immutable;

1;

