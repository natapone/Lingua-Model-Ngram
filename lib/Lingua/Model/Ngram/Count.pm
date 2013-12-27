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

has 'ngram_count'   => (is => 'ro', isa => 'HashRef', lazy => 1, builder => '_build_ngram_count');

our $df_count;

sub _build_ngram_count { return {}; }

# add Term frequency
sub add_ngram {
    my $self = shift;
    my $ngrams = shift;
    
#    print "ngrams == ", Dumper($ngrams);
    for my $ngram (@$ngrams) {
        my $key = $self->ngrams_to_key($ngram);
        
#        print "Add tot key == $key \n";
        $self->ngram_count->{$key}->{'TF'}++;
        
        # temp save to df_count before doc is close
        $df_count->{$key}++;
    }
##    print "ngram_count == ", Dumper($self->ngram_count);
##    print "df_count == ", Dumper($df_count);
    
    return 1;
}

# add Document frequency
sub add_df {
    my $self = shift;
    
    for my $df (keys %{$df_count}) {
        $self->ngram_count->{$df}->{'DF'}++;
    }
    $df_count = {};
    
##    print "ngram_count == ", Dumper($self->ngram_count);
##    print "df_count == ", Dumper($df_count);
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
