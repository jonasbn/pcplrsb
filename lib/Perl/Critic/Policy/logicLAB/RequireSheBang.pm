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
            ([\w/ ]+) #the path
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
    $self->{_formats} = [('#!/usr/local/bin/perl')];

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

__END__

=pod

=head1 NAME

Perl::Critic::Policy::logicLAB::RequireSheBang - <package abstract>

=head1 AFFILIATION 

This policy is a policy in the Perl::Critic::logicLAB distribution.

=head1 VERSION

This documentation describes version 0.01

=head1 DESCRIPTION

=head1 CONFIGURATION AND ENVIRONMENT

This policy allow you to configure the contents of the shebang lines you want to allow.

	[logicLAB::RequireSheBang]
	formats = #!/usr/local/bin/perl || #!/usr/bin/perl || #!perl || #!env perl

The default is:

	#!/usr/local/bin/perl
	
Please note that if you however what to extend the pattern, you also have to specify was is normally the default pattern
since configuration overwrites the default even for extension.

=head1 DEPENDENCIES AND REQUIREMENTS

=over

=item * L<Perl::Critic>

=item * L<Perl::Critic::Utils>

=item * L<Readonly>

=item * L<Test::More>

=item * L<Test::Perl::Critic>

=item * L<List::MoreUtils>

=back

=head1 INCOMPATIBILITIES

This distribution has no known incompatibilities.

=head1 BUGS AND LIMITATIONS

The distribution has now known bugs or limitations. It locates shebang lines through out the source code, not limiting itself to the first line. This might however change in the future, but will propably be made configurable is possible.

=head1 BUG REPORTING

Please use Requets Tracker for bug reporting:

    http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-logicLAB-RequireSheBang

=head1 TEST AND QUALITY

The following policies have been disabled for this distribution

=over

=item * L<Perl::Crititc::Policy::ValuesAndExpressions::ProhibitConstantPragma>

=item * L<Perl::Crititc::Policy::NamingConventions::Capitalization>

=back

See also F<t/perlcriticrc>

=head2 TEST COVERAGE
    
=head1 SEE ALSO

=over

=item * L<http://perldoc.perl.org/perlrun.html>

=item * L<http://logiclab.jira.com/wiki/display/OPEN/Development#Development-MakeyourComponentsEnvironmentAgnostic>

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen, jonasbn C<< <jonasbn@cpan.org> >>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011 Jonas B. Nielsen. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
