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
    
    my $ngram_counter = Lingua::Model::Ngram::Count->new();
    my $ngram_key = $ngram_counter->ngrams_to_key([1,2,3]);
    my $expected_key = '1-2-3';
    is($ngram_key, $expected_key, "n-gram key is correct '$ngram_key'");
    
    $ngram_key = $ngram_counter->ngrams_to_key(['*',1,'STOP']);
    $expected_key = '*-1-STOP';
    is($ngram_key, $expected_key, "n-gram key is correct '$ngram_key'");
    
    $ngram_counter->add_ngram($tri_ngrams);
    my $expected_count = {
            '1-2-3' => {'TF' => 1},
            '2-3-4' => {'TF' => 1},
            '3-4-5' => {'TF' => 1},
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
    $ngram_counter->add_ngram($tri_ngrams);
    $expected_count = {
            '1-2-3' => {'TF' => 2},
            '2-3-4' => {'TF' => 2},
            '3-4-5' => {'TF' => 2},
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
    $ngram_counter->add_ngram($bi_ngrams);
    $expected_count = {
            '1-2-3' => {'TF' => 2},
            '2-3-4' => {'TF' => 2},
            '3-4-5' => {'TF' => 2},
            '1-2'   => {'TF' => 1},
            '2-3'   => {'TF' => 1},
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "ngram_count is correct");
    
    # Trigger end document to create "DF"
    $ngram_counter->add_df;
    $expected_count = {
            '1-2-3' => {'TF' => 2, 'DF' => 1},
            '2-3-4' => {'TF' => 2, 'DF' => 1},
            '3-4-5' => {'TF' => 2, 'DF' => 1},
            '1-2'   => {'TF' => 1, 'DF' => 1},
            '2-3'   => {'TF' => 1, 'DF' => 1},
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "Document frequency count is correct");
    
    $ngram_counter->add_ngram($bi_ngrams);
    $ngram_counter->add_df;
    $expected_count = {
            '1-2-3' => {'TF' => 2, 'DF' => 1},
            '2-3-4' => {'TF' => 2, 'DF' => 1},
            '3-4-5' => {'TF' => 2, 'DF' => 1},
            '1-2'   => {'TF' => 2, 'DF' => 2},
            '2-3'   => {'TF' => 2, 'DF' => 2},
    };
    is_deeply($ngram_counter->return_ngram_count, $expected_count, "Document frequency count is correct");
};




