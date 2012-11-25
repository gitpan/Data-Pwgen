package Data::Pwgen;
{
  $Data::Pwgen::VERSION = '0.12';
}
BEGIN {
  $Data::Pwgen::AUTHORITY = 'cpan:TEX';
}
# ABSTRACT: simple password generation and assessment

use warnings;
use strict;
use 5.008;


{
## no critic (ProhibitNoisyQuotes)
    my %rep = (
        'nums'  => [ '0' .. '9' ],
        'signs' => [ '%', '$', '_', '-', '+', '*', '&', '/', '=', '!', '#' ],
        'lower' => [ 'a' .. 'z' ],
        'upper' => [ 'A' .. 'Z' ],
    );
## use critic
    $rep{'chars'}    = [ @{ $rep{'lower'} },    @{ $rep{'upper'} } ];
    $rep{'alphanum'} = [ @{ $rep{'chars'} },    @{ $rep{'nums'} } ];
    $rep{'alphasym'} = [ @{ $rep{'alphanum'} }, @{ $rep{'signs'} } ];
    my $entropy = 0;

    ## no critic (ProhibitMagicNumbers)
    my $default_length = 16;
    my $min_length = 8;
    ## use critic

    sub pwgen {
        my $length = shift || $default_length;
        my $class  = shift || 'alphanum';
        $rep{$class} or $class = 'alphanum';
        $entropy++;
        srand( time() + $entropy );
        my $pw = join( q{}, map { $rep{$class}[ rand( $#{ $rep{$class} } ) ] } 0 .. $length - 1 );
        return $pw;
    }

    sub strength {
        my $pw       = shift;
        my $strength = 0;
        $strength += length($pw) - ($min_length+1);
        $strength++ if ( $pw =~ m/[a-z]/ );         # lower case alpha
        $strength++ if ( $pw =~ m/[A-Z]/ );         # upper case alpha
        $strength++ if ( $pw =~ m/[0-9]/ );         # numbers
        $strength++ if ( $pw =~ m/[^A-Z0-9]/i );    # non-alphanums
        return $strength;
    }
}

1; # End of Data::Pwgen

__END__

=pod

=encoding utf-8

=head1 NAME

Data::Pwgen - simple password generation and assessment

=head1 SYNOPSIS

    use Data::Pwgen;
    my $pass = &Data::Pwgen::pwgen(12);
    my $str = &Data::Pwgen::strength($pass);

=head1 DESCRIPTION

This is a simple module that implements generation and assesment of secure passwords.

=head1 FUNCTIONS

=head2 pwgen

Generate a passwort with the (optional) given length and (also optional) given character class.

=head2 strength

Returns a numeric rating of the quality of the supplied (password) string.

=head1 NAME

Data::Pwgen - Password generation and assessment

=head1 AUTHOR

Dominik Schulz <dominik.schulz@gauner.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Dominik Schulz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
