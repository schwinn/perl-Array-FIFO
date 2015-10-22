package Array::FIFO;

use Moose;
use List::Util qw(sum0);

use namespace::autoclean;


=head1 NAME

Array::FIFO - A Simple limitable FIFO array, with a few convenience methods to do crunch the data

=head1 SYNOPSIS

    my $ar = Array::FIFO->new( limit => 12 );
    $ar->add( 20 );
    $ar->add( 18 );
    $ar->add( 22 );

    say $ar->average;

=head1 DESCRIPTION

Provides access to doppler data via a Doppler::Storage::Engine package
through an interface provided by a Doppler::Storage::Interface role.

=head1 METHODS

=head2 C<new>

=over 4

=item C<limit> (optional)

Numeric value of how large the array is allowd to get.  When it reaches 
limit, every item added causes the oldest item to be removed.

If no value is passed, there is no max size.


=back

=head2 C<add>

    $ar->add( 99 );

You can add any type of item to the array; if it's not a number it will just
not affect the sum() or average() calculations.

=head2 C<remove>

    $ar->remove;

Remove the oldest item on the array.

=head2 C<queue>

    $ar->queue;

Reference directly the fifo array.

=head2 C<size>

    $ar->size;

How many elements are in the array.

=head2 C<limit>

    $ar->limit;

The maximum size the array is allow to be.

=head2 C<sum>

    $ar->sum;

The sum of all numeric elements in the array.

=head2 C<average>

    $ar->average;

The average of all numeric elements in the array.

=head1 AUTHOR

Dan Burke C<< dburke at addictmud.org >>

=head1 BUGS

If you encounter any bugs, or have feature requests, please create an issue 
on github. https://github.com/dwburke/perl-Array-FIFO/issues

=head1 LICENSE AND COPYRIGHT

L<http://www.perlfoundation.org/artistic_license_2_0>

=cut


has limit => ( is => 'rw', isa => 'Int', default => -1 );

has queue => (
    is => 'rw',
    isa => 'ArrayRef[Item]', 
    traits => [ 'Array' ],
    default => sub { [ ] },
    handles => {
        add => 'push',
        remove => 'shift',
        size => 'count',
    },
    trigger => sub {
        my $self = shift;

        if ($self->{limit} > 0) {
            my $array = $self->{queue};
            while (@{ $array } > $self->{limit}) {
                shift @{ $array };
            }
        }

        my $size = $self->size;

        my $sum = sum0( grep /^-?\d+\.?\d*$/, @{ $self->queue } );

        $self->sum( $sum );
        if ($sum > 0) {
            $self->average( $sum / $size );
        }
        else {
            $self->average(0);
        }
    },
    );

around add => sub {
    my $orig = shift;
    my $self = shift;

    my $last = $self->{queue}[0];

    $self->$orig( @_ );

    $last;
};

has sum => ( is => 'rw', isa => 'Int' );
has average => ( is => 'rw', isa => 'Num' );


__PACKAGE__->meta->make_immutable;

1;

