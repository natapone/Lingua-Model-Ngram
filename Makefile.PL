use inc::Module::Install;

name 'Lingua-Model-Ngram';
all_from 'lib/Lingua/Model/Ngram.pm';

build_requires 'Test::Perl::Critic';

requires 'Try::Tiny';
requires 'Data::Dumper';
requires 'Moose';

test_requires 'Test::More';

auto_install;

WriteAll;
