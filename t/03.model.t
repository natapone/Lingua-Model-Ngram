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

subtest 'Calculate N-grams probability from combination' => sub {
    
    # restore hash 
    my $ngram_count = retrieve('./t/data/ngram_count.hash') || die "Missing Ngram file";
#    print Dumper($ngram_count); exit;
    
    my $model_engine = Lingua::Model::Ngram->new(
                                        ngram_count     => $ngram_count,
                                    );
    
    my $grams = [9067, 4884, 14642]; # occur = 5
    my $p1 = $model_engine->sentence_probability($grams);
    
    $grams = [3179,28898,28898]; # occur = 1
    my $p2 = $model_engine->sentence_probability($grams);
    
    ok($p1 > $p2, "Return sentences probability correctly");
    
    $grams = [9067, 4884, 99999]; # new word
    my $p3 = $model_engine->sentence_probability($grams);
    is($p3, 0, "Probability of new word 99999 = 0");
    
    $grams = [20503, 6436, 2666];
    $p1 = $model_engine->sentence_probability($grams);
    
    $grams = [6436, 2666, 125];
    $p2 = $model_engine->sentence_probability($grams);
    
    $grams = [20503, 6436, 2666, 125];
    $p3 = $model_engine->sentence_probability($grams);
    
    ok($p1 > $p3, "Longer grams have less probability");
    ok($p2 > $p3, "Longer grams have less probability");
    
    print "$p1 / $p2 / $p3 \n";
};

