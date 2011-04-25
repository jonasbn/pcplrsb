
# $Id$

use strict;
use warnings;
use Test::More tests => 14;
use Env qw($TEST_VERBOSE);

use_ok 'Perl::Critic::Policy::logicLAB::RequireSheBang';

require Perl::Critic;

my $critic = Perl::Critic->new(
    '-profile'       => 't/example.conf',
    '-single-policy' => 'logicLAB::RequireSheBang'
);
{
    my $str = q[#!/usr/bin/perl];
    
    my @violations = $critic->critique( \$str );
    
    is(scalar @violations, 0, "asserting no violations for: $str");
}

{
    my $str = q[#!perl];
    
    my @violations = $critic->critique( \$str );
    
    is(scalar @violations, 0, "asserting no violations for: $str");
}

{
    my $str = q[#!env perl];
    
    my @violations = $critic->critique( \$str );
    
    is(scalar @violations, 0, "asserting no violations for: $str");
}

{
    my $str = q[#!/usr/local/bin/perl];
    
    my @violations = $critic->critique( \$str );
    
    is(scalar @violations, 0, "asserting no violations for: $str");
}

$critic = Perl::Critic->new(
    '-profile'       => '',
    '-single-policy' => 'logicLAB::RequireSheBang'
);
{
    my $str = q[#!perl];
    
    my @violations = $critic->critique( \$str );
    
    is(scalar @violations, 0, "asserting no violations for: $str");
}

$critic = Perl::Critic->new(
    '-profile'       => '',
    '-single-policy' => 'logicLAB::RequireSheBang'
);
{
    my @p = $critic->policies;
    is( scalar @p, 1, 'single policy RequireSheBang' );

    my $policy = $p[0];
}
print STDERR "\n";

my @lines = <DATA>;
my $i = 1;

foreach (@lines) {
    chomp $_;
    my ($want_count, $str) = split /\t/;
    my @violations = $critic->critique( \$str );
    foreach (@violations) {
        is( $_->description, q{she-bang line not confirming with requirement}, "statement: $str" );
    }
    is( scalar @violations, $want_count, "$i: statement: $str" );

    if ($TEST_VERBOSE) {
        if ($want_count) {
            warn "$str does not conform\n";
        } else {
            warn "$str conforms\n";
        }
    }

    $i++;
}

exit 0;

__DATA__
1	#!env perl
1	#!/usr/local/bin/perl
1	#!/usr/bin/perl
0	#!perl
