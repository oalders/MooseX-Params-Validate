#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

{
    package Foo;
    use Moose;
    use MooseX::Params::Validate;

    sub bar {
        my ( $self, $args, $params ) = @_;
        $params->{MX_PARAMS_VALIDATE_NO_CACHE}++;
        return validated_hash( $args, %$params );
    }
}

my $foo = Foo->new;
isa_ok( $foo, 'Foo' );

lives_ok {
    $foo->bar( [ baz => 1 ], { baz => { isa => 'Int' } } );
}
'... successfully applied the parameter validation';

lives_ok {
    $foo->bar( [ baz => [ 1, 2, 3 ] ], { baz => { isa => 'ArrayRef' } } );
}
'... successfully applied the parameter validation (look mah no cache)';

lives_ok {
    $foo->bar( [ baz => { one => 1 } ], { baz => { isa => 'HashRef' } } );
}
'... successfully applied the parameter validation (look mah no cache) (just checkin)';

done_testing();
