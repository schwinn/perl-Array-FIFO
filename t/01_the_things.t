
use Test::Spec; # automatically turns on strict and warnings
use FindBin;
use lib "$FindBin::Bin/../lib";

use Array::FIFO;

describe "Array::FIFO" => sub {

    describe "adds an element" => sub {
        my $ar;

        before each => sub {
            $ar = Array::FIFO->new( max_size => 5 );
            $ar->add( 5 );
        };

        it "size is 1" => sub {
            is( $ar->size, 1 );
        };

        it "average is 5" => sub {
            is( $ar->average, 5 );
        };

        it "sum is 5" => sub {
            is( $ar->sum, 5 );
        };

    };

    describe "adds multiple elements" => sub {
        my $ar;

        before each => sub {
            $ar = Array::FIFO->new( max_size => 5 );
            $ar->add( 3 );
            $ar->add( 6 );
            $ar->add( 9 );
        };

        it "size is 3" => sub {
            is( $ar->size, 3 );
        };

        it "average is 6" => sub {
            is( $ar->average, 6 );
        };

        it "sum is 18" => sub {
            is( $ar->sum, 18 );
        };

    };

    describe "adds over max elements" => sub {
        my $ar;

        before each => sub {
            $ar = Array::FIFO->new( max_size => 5 );
            $ar->add( 3 );
            $ar->add( 6 );
            $ar->add( 9 );
            $ar->add( 12 );
            $ar->add( 15 );
            $ar->add( 18 );
        };

        it "size is 5" => sub {
            is( $ar->size, 5 );
        };

        it "average is 12" => sub {
            is( $ar->average, 12 );
        };

        it "sum is 60" => sub {
            is( $ar->sum, 60 );
        };

    };

};

runtests unless caller;

