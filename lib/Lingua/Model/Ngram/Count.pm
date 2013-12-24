package Lingua::Model::Ngram::Count;

use strict;
use warnings;
use Moose;

use Data::Dumper;

our $VERSION = '0.01';

=head1 NAME
Lingua::Model::Ngram::Count

=head1 DESCRIPTION
Count Ngrams

=cut

has 'ngram_count' => (is => 'ro', isa => 'HashRef', lazy => 1, builder => '_build_ngram_count');

sub _build_ngram_count { return {}; }

sub add_ngram {
    my $self = shift;
    my $ngrams = shift;
    
#    print "ngrams == ", Dumper($ngrams);
    for my $ngram (@$ngrams) {
#        print Dumper($ngram );
        
        my $key = $self->ngrams_to_key($ngram);
        
#        print "Add tot key == $key \n";
        $self->ngram_count->{$key}++;
    }
    
##    print "ngram_count == ", Dumper($self->ngram_count);
    return 1;
}

sub return_ngram_count {
    my $self = shift;
    
    return $self->ngram_count;
}

sub ngrams_to_key {
    my $self = shift;
    my $ngrams = shift;
    
    return join('-', @$ngrams);
}

1;
