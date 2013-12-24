#!/usr/bin/perl -w
use strict;
use warnings;

use Test::More tests => 3;
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
    
    # use window size = [3, 2, 1, 0] to calculate 'linear interpolation estimation'
    $params = {
        window_size => 2,
    };
    $ngrams = $text_engine->ngram($tokens, $params);
    $expected_ngrams = [
            [1,2],
            [2,3],
            [3,4],
            [4,5],
            [5,6],
            [6,7],
            [7,8],
            [8,9],
            [9,10],
    ];
    is_deeply($ngrams, $expected_ngrams, "return default bi-grams correctly");
    
    $params = {
        window_size => 1,
    };
    $ngrams = $text_engine->ngram($tokens, $params);
    $expected_ngrams = [
            [1],
            [2],
            [3],
            [4],
            [5],
            [6],
            [7],
            [8],
            [9],
            [10],
    ];
    is_deeply($ngrams, $expected_ngrams, "return default uni-grams correctly");
    
    # use window size = 0 to get array for corpus counting
    $params = {
        window_size => 0,
    };
    $ngrams = $text_engine->ngram($tokens, $params);
    $expected_ngrams = [
          'CORPUS', 'CORPUS', 'CORPUS',
          'CORPUS', 'CORPUS', 'CORPUS',
          'CORPUS', 'CORPUS', 'CORPUS',
          'CORPUS'
        ];
    is_deeply($ngrams, $expected_ngrams, "return grams for corpus count correctly");
    
#    print Dumper($ngrams);
};

subtest 'Ngram with START STOP sequence' => sub {
    my $params = {
        start_stop => 1,
    };
    my $ngrams = $text_engine->ngram($short_tokens, $params);
    my $expected_ngrams = [
            ['*','*',1],
            ['*',1,2],
            [1,2,'STOP'],
    ];
    is_deeply($ngrams, $expected_ngrams, "return tri-grams with START, STOP sequence");
    
    $params = {
        start_stop => 1,
        window_size => 2,
    };
    $ngrams = $text_engine->ngram($short_tokens, $params);
    $expected_ngrams = [
            ['*','*'],
            ['*',1],
            [1,2],
            [2,'STOP'],
    ];
    is_deeply($ngrams, $expected_ngrams, "return bi-grams with START, STOP sequence");
    
    $params = {
        start_stop => 1,
        window_size => 1,
    };
    $ngrams = $text_engine->ngram($short_tokens, $params);
    $expected_ngrams = [
            ['*'],
            [1],
            [2],
            ['STOP'],
    ];
    is_deeply($ngrams, $expected_ngrams, "return uni-grams with START, STOP sequence");
    
    $params = {
        start_stop => 1,
        window_size => 0,
    };
    $ngrams = $text_engine->ngram($tokens, $params);
    $expected_ngrams = [
          'CORPUS', 'CORPUS', 'CORPUS', 'CORPUS',
          'CORPUS', 'CORPUS', 'CORPUS', 'CORPUS',
          'CORPUS', 'CORPUS', 'CORPUS', 'CORPUS'
        ];
    is_deeply($ngrams, $expected_ngrams, "return grams for corpus count correctly");
    
#    print Dumper($ngrams);
};



