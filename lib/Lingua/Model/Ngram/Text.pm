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
};

has 'markov_order'  => (is => 'rw', isa => 'Int', default => 2);

sub ngram () {
    my $self = shift;
    my $tokens_ref = shift;
    my $params = shift;
    
    my @tokens = @$tokens_ref;
    
#    print "tokens == ", Dumper(\@tokens);
    
    # setup parameters
    # windows size
    my $window_size = $params->{'window_size'} || 3;
    my $add_start_stop = $params->{'start_stop'} || 0;
    
    # 2 nd order Markov Chain => *, *, w1, w2, w3, STOP
    if ($add_start_stop) {
        my @start_tokens = (START_SEQ) x $self->markov_order;
        
        unshift(@tokens, @start_tokens);
        push(@tokens, STOP_SEQ);
        
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
