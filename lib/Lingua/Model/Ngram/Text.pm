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
