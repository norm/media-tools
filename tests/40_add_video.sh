#!/usr/bin/env bats

source bin/media

function count_files_in_dir {
    find "$1" -type f \
        | wc -l \
        | tr -d ' '
}

function is_empty {
    [ "$( count_files_in_dir "$1" )" = 0 ]
}


@test "adds a TV show" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )

    # there should be nothing before we begin
    is_empty "$MEDIA_TV_BASE"

    media-add "tests/process/House - 1x01 - Pilot"

    # media-add should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]

    local installed="$MEDIA_TV_BASE/House/Season 1/01 Pilot.m4v"
    [ -f "$installed" ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'House' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '1' ]
    [ "$( media_lookup_atom "$installed" tves )" = '1' ]
    [ "$( media_lookup_atom "$installed" tven )" = '1x01' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Pilot' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE
}

@test "cleans up directories when TRASH_DIR set" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TRASH_DIR=$( mktemp -d )
    local -r convert_dir=$( mktemp -d )

    # there should be nothing before we begin
    is_empty "$MEDIA_TV_BASE"
    is_empty "$MEDIA_TRASH_DIR"
    is_empty "$convert_dir"

    local source="$convert_dir/House - 1x01 - Pilot"
    mkdir "$source"
    cp tests/source/tiny.mp4 "$source"
    cp tests/source/tv.jpg "$source/poster.jpg"
    cp tests/source/tv.jpg "$source/poster-resized-4482.jpg"

    media-add "$source"

    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]
    [ $( count_files_in_dir "$MEDIA_TRASH_DIR" ) = 1 ]
    is_empty "$convert_dir"

    local installed="$MEDIA_TV_BASE/House/Season 1/01 Pilot.m4v"
    [ -f "$installed" ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'House' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '1' ]
    [ "$( media_lookup_atom "$installed" tves )" = '1' ]
    [ "$( media_lookup_atom "$installed" tven )" = '1x01' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Pilot' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE $MEDIA_TRASH_DIR $convert_dir
}
