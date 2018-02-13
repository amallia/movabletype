# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::CategorySet;
use strict;
use warnings;

use MT::CategorySet;

sub view {
    my $app = shift;

    return $app->permission_denied
        if ( !$app->user->is_superuser()
        && !$app->user->can_manage_content_types()
        && !$app->can_do('edit_category_set') );

    if ( my $set_id = $app->param('id') ) {
        unless ( MT::CategorySet->exist($set_id) ) {
            return $app->errtrans( 'Invalid category_set_id: [_1]', $set_id );
        }
    }

    $app->param( '_type',           'category' );
    $app->param( 'is_category_set', 1 );
    $app->forward('list');
}

sub list_actions {
    {   delete => {
            label      => 'Delete',
            code       => '$Core::MT::Common::delete',
            mode       => 'delete',
            order      => 100,
            js_message => 'delete',
            button     => 1,
            permission => 'manage_category_set,manage_content_types',
        },
    };
}

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;
    my $user = $app->user;
    return unless $user;

    return 1
        if ( $user->is_superuser() || $user->can_manage_content_types() );

    $user->permissions( $app->blog->id )
        ->can_do('access_to_category_set_list');
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    return unless $id;

    my $user = $app->user;
    return unless $user;
    return 1 if ( $user->is_superuser || $user->can_manage_content_types() );

    my $obj = $objp->force or return 0;
    $user->permissions( $obj->blog_id )->can_do('edit_category_set');
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $user = $app->user;
    return unless $user;

    return 1
        if ( $user->is_superuser() || $user->can_manage_content_types() );
    $app->can_do('save_category_set');
}

sub can_delete {
    my ( $eh, $app, $set ) = @_;
    my $author = $app->user;
    return 1
        if ( $author->is_superuser() || $author->can_manage_content_types() );

    if ( $set && !ref $set ) {
        $set = MT::CategorySet->load($set)
            or return;
    }

    my $blog_id = $set ? $set->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_category_set');
}

1;
