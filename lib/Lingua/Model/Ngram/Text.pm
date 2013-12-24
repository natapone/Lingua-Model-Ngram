package Lingua::Model::Ngram::Text;

use strict;
use warnings;
use Moose;

use Data::Dumper;

our $VERSION = '0.01';

=head1 NAME
Lingua::Model::Ngram::Text

=head1 DESCRIPTION
Text support function
- N-gram

=cut

use constant {
    START_SEQ   => '*',
    STOP_SEQ    => 'STOP',
    CORPUS_SEQ  => 'CORPUS',
};

has 'markov_order'  => (is => 'rw', isa => 'Int', default => 2);

sub ngram () {
    my $self = shift;
    my $tokens_ref = shift;
    my $params = shift;
    
    my @tokens = @$tokens_ref;
    
    # setup parameters
    # windows size
    my $window_size = defined($params->{'window_size'}) ? $params->{'window_size'} : 3;
    
    my $add_start_stop = $params->{'start_stop'} || 0;
    
    # 2 nd order Markov Chain => *, *, w1, w2, w3, STOP
    if ($add_start_stop) {
        my $start_length = $self->markov_order;
        # should count only 1 '*'
        if ($window_size <= 1) {
            $start_length = 1;
        }
        my @start_tokens = (START_SEQ) x $start_length;
        
        unshift(@tokens, @start_tokens);
        push(@tokens, STOP_SEQ);
        
    }
    
#    print "tokens == ", Dumper(\@tokens);
    
    # SPECIAL: if windows size => split and return array with same value
    #          use for counting number of corpus
    
    if ($window_size == 0) {
        my @corpus_count = (CORPUS_SEQ) x (scalar @tokens);
        return \@corpus_count;
    }
    
    my @ngram_sequences;
    while (scalar @tokens >= $window_size) {
        my @ngrams = @tokens[0 .. $window_size - 1];
        push(@ngram_sequences, \@ngrams);
#        print "@ngrams\n";
        
        shift(@tokens); # delete first element
    }
    
    
    return \@ngram_sequences;
}

1;
