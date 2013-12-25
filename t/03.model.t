#!/usr/bin/perl -w
use strict;
use warnings;

use Test::More tests => 3;
BEGIN { use_ok('Lingua::Model::Ngram') };

use Data::Dumper;
use Storable;

subtest 'N-grams model probability combination' => sub {
    
    my $trigram_keywords = [1,2,3];
    my $ninegram_keywords = [1,2,3,4,5,6,7,8,9];
    
    my $model_engine = Lingua::Model::Ngram->new();
    
    # format is [ numerator / denominator ]
    my $combos = $model_engine->_probability_combination($trigram_keywords);
    my $expected_combos = [
        [
            [ '*-*-1', '*-*' ],
            [ '*-1', '*' ],
            [ '1', 'CORPUS' ],
        ],
        [
            [ '*-1-2', '*-1' ],
            [ '1-2', '1' ],
            [ '2', 'CORPUS' ],
        ],
        [
            [ '1-2-3', '1-2' ],
            [ '2-3', '2' ],
            [ '3', 'CORPUS' ],
        ],
        [
            [ '2-3-STOP', '2-3' ],
            [ '3-STOP', '3' ],
            [ 'STOP', 'CORPUS' ,]
        ],
    ];
    is_deeply($combos, $expected_combos, "Tri-grams probability are correct");
    
    
    $combos = $model_engine->_probability_combination($ninegram_keywords);
    $expected_combos = [
        [
            [ '*-*-1', '*-*' ],
            [ '*-1', '*' ],
            [ '1', 'CORPUS' ],
        ],
        [
            [ '*-1-2', '*-1' ],
            [ '1-2', '1' ],
            [ '2', 'CORPUS' ],
        ],
        [
            [ '1-2-3', '1-2' ],
            [ '2-3', '2' ],
            [ '3', 'CORPUS' ],
        ],
        [
            [ '2-3-4', '2-3' ],
            [ '3-4', '3' ],
            [ '4', 'CORPUS' ],
        ],
        [
            [ '3-4-5', '3-4' ],
            [ '4-5', '4' ],
            [ '5', 'CORPUS' ],
        ],
        [
            [ '4-5-6', '4-5' ],
            [ '5-6', '5' ],
            [ '6', 'CORPUS' ],
        ],
        [
            [ '5-6-7', '5-6' ],
            [ '6-7', '6' ],
            [ '7', 'CORPUS' ],
        ],
        [
            [ '6-7-8', '6-7' ],
            [ '7-8', '7' ],
            [ '8', 'CORPUS' ],
        ],
        [
            [ '7-8-9', '7-8' ],
            [ '8-9', '8' ],
            [ '9', 'CORPUS' ],
        ],
        [
            [ '8-9-STOP', '8-9' ],
            [ '9-STOP', '9' ],
            [ 'STOP', 'CORPUS' ],
        ],
    ];
    is_deeply($combos, $expected_combos, "Nine-grams probability are correct");
};

##subtest 'Calculate N-grams probability from combination' => sub {
##    
##    # restore hash 
##    
##    my 
##    
##    
##};

