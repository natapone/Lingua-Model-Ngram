package Lingua::Model::Ngram;

use strict;
use warnings;
use Moose;

use Lingua::Model::Ngram::Text;
use Lingua::Model::Ngram::Count;

use Data::Dumper;

our $VERSION = '0.01';

=head1 NAME
Lingua::Model::Ngram

=head1 DESCRIPTION
Ngrams model helper

=cut

has 'markov_order' => (is => 'ro', isa => 'Int', lazy => 1, default => 2);

has 'text_engine' => (is => 'ro', isa => 'Lingua::Model::Ngram::Text', 
                    lazy => 1, builder => '_build_text_engine');

has 'ngram_counter' => (is => 'ro', isa => 'Lingua::Model::Ngram::Count', 
                    lazy => 1, builder => '_build_ngram_counter');

sub _build_text_engine {
    return Lingua::Model::Ngram::Text->new();
}

sub _build_ngram_counter {
    return Lingua::Model::Ngram::Count->new();
}

sub _probability_combination {
    my $self = shift;
    my $grams = shift;
    
    my $params = {
        start_stop => 1,
        window_size => $self->markov_order + 1,
    };
    my $ngrams = $self->text_engine->ngram($grams, $params);
    
    # extract sequence
    my @combos;
    for my $ws (@$ngrams) {
#        print Dumper($ws);
        
        my @lambda;
        my $ngram_length = scalar @$ws;
        
        for my $num_count (0 .. $ngram_length - 1) {
            my @w_numerator = @$ws[$num_count .. $ngram_length - 1];
            
            my $num_length = scalar @w_numerator;
            my @w_denominator = @w_numerator [0 .. $num_length - 2];
            
#            print "--- numerator ", @w_numerator ;
#            print " / ", @w_denominator ;
#            print "\n";
            
#            print "[ ";
#            print "'",$self->ngram_counter->ngrams_to_key(\@w_numerator), "'";
#            print ", ";
#            if (@w_denominator){
#                print "'",$self->ngram_counter->ngrams_to_key(\@w_denominator), "'";
#            } else {
#                print "'", Lingua::Model::Ngram::Text::CORPUS_SEQ , "'" ;
#            }
#            print " ],\n";
            
            # numerator / denominator
            push(@lambda, [
                $self->ngram_counter->ngrams_to_key(\@w_numerator), 
                (@w_denominator) ?
                    $self->ngram_counter->ngrams_to_key(\@w_denominator) : 
                    Lingua::Model::Ngram::Text::CORPUS_SEQ
                ]
            );
        }
        push(@combos, \@lambda);
#        print "\n-----------------\n";
        
    }
    
#    print "Combo == ", Dumper(\@combos);
    return \@combos;
}




1;
