#!/usr/bin/perl -w
use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('Lingua::Model::Ngram::Count') };

use Data::Dumper;

my $tri_ngrams = [
            [1,2,3],
            [2,3,4],
            [3,4,5],
];

my $bi_ngrams = [
            [1,2],
            [2,3],
];

subtest 'Add N-grams' => sub {
    
#    for my $gram (@$tri_ngrams) {
#        print Dumper($gram );
#    }
    
    my $ngram_counter = Lingua::Model::Ngram::Count->new();
    my $ngram_key = $ngram_counter->ngrams_to_key([1,2,3]);
    my $expected_key = '1-2-3';
    is($ngram_key, $expected_key, "n-gram key is correct '$ngram_key'");
    
    $ngram_key = $ngram_counter->ngrams_to_key(['*',1,'STOP']);
    $expected_key = '*-1-STOP';
    is($ngram_key, $expected_key, "n-gram key is correct '$ngram_key'");
    
    $ngram_counter->add_ngram($tri_ngrams);
    my $expected_count = {
            '1-2-3' => 1,
            '2-3-4' => 1,
            '3-4-5' => 1,
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
    $ngram_counter->add_ngram($tri_ngrams);
    my $expected_count = {
            '1-2-3' => 2,
            '2-3-4' => 2,
            '3-4-5' => 2,
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
    $ngram_counter->add_ngram($bi_ngrams);
    my $expected_count = {
            '1-2-3' => 2,
            '2-3-4' => 2,
            '3-4-5' => 2,
            '1-2'   => 1,
            '2-3'   => 1,
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
};


