#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;

use MT::Entry;

my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

my $mt = MT->instance;

my $user2 = MT::Test::Permission->make_author;
my $ct1   = MT::Test::Permission->make_content_type(
    name    => 'test content type 1',
    blog_id => $blog_id,
);
$vars->{ct1_id}  = $ct1->id;
$vars->{ct1_uid} = $ct1->unique_id;
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::RELEASE(),
) for ( 1 .. 5 );
MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::HOLD(),
);
MT::Test::Permission->make_content_data(
    author_id       => $user2->id,
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    status          => MT::Entry::RELEASE(),
);

MT::Test::Tag->run_perl_tests($blog_id);
# MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MT::AuthorContentCount
--- template
<mt:Authors id="1"><mt:AuthorContentCount blog_id="1" name="test content type 1"></mt:Authors>
--- expected
5

