#!/usr/local/bin/perl

# $Id$

use strict;
use warnings;
use Perl::Critic;
use File::Slurp qw(slurp);
use Data::Dumper;
use autodie;

my $str = slurp($ARGV[0]);

print STDERR "Critizicing file: $ARGV[0]\n";

print STDERR "We have Perl\n++++++++++\n$str\n++++++++++\n";

my $critic = Perl::Critic->new(
    '-single-policy' => 'logicLAB::RequireSheBang',
    '-profile'       => '',
);

print STDERR Dumper $critic;

my @violations = $critic->critique( \$str );

print STDERR Dumper @violations;