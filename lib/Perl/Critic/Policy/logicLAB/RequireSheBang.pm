package Perl::Critic::Policy::logicLAB::RequireSheBang;

# $Id$

use strict;
use warnings;
use base 'Perl::Critic::Policy';
use Perl::Critic::Utils qw{ $SEVERITY_MEDIUM :booleans };
use List::MoreUtils qw(none);

our $VERSION = '0.01';

Readonly::Scalar my $EXPL => q{she-bang line should adhere to requirement};

use constant supported_parameters => ();
use constant default_severity     => $SEVERITY_MEDIUM;
use constant default_themes       => qw(maintenance);
use constant supported_parameters => qw(formats);

sub applies_to {
    return (
        qw(
            PPI::Token::Comment
            )
    );
}

sub violates {
    my ( $self, $elem ) = @_;

    my ($shebang, $cli) = $elem =~ m{
            \A  #beginning of string
            (\#!) #actual she-bang
            ([\w/ ]+)
            \Z  #end of string
    }xsm;
    
    if ($shebang && none { ($shebang.$cli) eq $_ } @{ $self->{_formats} }) {
        return $self->violation( q{she-bang line not confirming with requirement},
            $EXPL, $elem );
    }

    return;
}

sub initialize_if_enabled {
    my ( $self, $config ) = @_;

    #Setting the default
    $self->{_formats} = [('#!perl')];

	#fetching configured formats
    my $formats = $config->get('formats');
    
	#parsing configured formats, see also _parse_formats
    if ($formats) {
        $self->{_formats} = $self->_parse_formats( $formats );
    }

    return $TRUE;
}

sub _parse_formats {
    my ( $self, $config_string ) = @_;

    my @formats = split m{ \s* [||]+ \s* }xsm, $config_string;
    
    return \@formats
}

1;
