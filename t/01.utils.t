#!/usr/bin/perl -w
use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('Lingua::Model::Ngram::Text') };

use Data::Dumper;

my $tokens = [
    1,2,3,4,5,6,7,8,9,10
];

my $short_tokens = [
    1,2
];

my $text_engine = Lingua::Model::Ngram::Text->new();

subtest 'Ngram sequence' => sub {
    
#    my @days = qw/Mon Tue Wed Thu Fri Sat Sun/;
#    my @weekdays = @days[0 .. 3];
#    print "@weekdays\n";
    
    
    
    # default Tri-gram
    my $ngrams = $text_engine->ngram($tokens);
    my $expected_ngrams = [
            [1,2,3],
            [2,3,4],
            [3,4,5],
            [4,5,6],
            [5,6,7],
            [6,7,8],
            [7,8,9],
            [8,9,10],
        ];
    is_deeply($ngrams, $expected_ngrams, "return default tri-grams correctly");
    
    my $params = {
        window_size => 7
    };
    $ngrams = $text_engine->ngram($tokens, $params);
    $expected_ngrams = [
            [1,2,3,4,5,6,7],
            [2,3,4,5,6,7,8],
            [3,4,5,6,7,8,9],
            [4,5,6,7,8,9,10],
    ];
    is_deeply($ngrams, $expected_ngrams, "return seven-grams correctly");
    
    # tokens shorter than window size
    $ngrams = $text_engine->ngram($short_tokens);
    $expected_ngrams = [];
    
    is_deeply($ngrams, $expected_ngrams, "return empty if tokens are shorter than window size");
    
#    print Dumper($ngrams);
    
    
}
