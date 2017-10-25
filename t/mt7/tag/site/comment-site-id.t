#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test qw(:db :data);
use MT::Test::Permission;

filters {
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests;

__END__

=== mt:CommentSiteID - blog
--- blog_id
1
--- template
<mt:Comments lastn="1"><mt:CommentSiteID></mt:Comments>
--- expected
1

=== mt:CommentSiteId - website
--- blog_id
2
--- template
<mt:Comments lastn="1"><mt:CommentSiteID></mt:Comments>
--- expected
2
