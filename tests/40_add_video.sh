#!/usr/bin/env bats

source bin/media
source tests/lib.sh


@test "adds a TV show" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"

    media-add-video "tests/process/House - 1x01 - Pilot"

    # media-add-video should have installed converted TV
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

@test "works with extended episodes" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"

    media-add-video "tests/process/Brooklyn Nine-Nine - 4x11-12 - Fugitive"

    # media-add-video should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]

    local installed="$MEDIA_TV_BASE/Brooklyn Nine-Nine/Season 4/11 Fugitive.m4v"
    [ -f "$installed" ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'Brooklyn Nine-Nine' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '4' ]
    [ "$( media_lookup_atom "$installed" tves )" = '11' ]
    [ "$( media_lookup_atom "$installed" tven )" = '4x11-12' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Fugitive' ]
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
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$MEDIA_TRASH_DIR"
    dir_is_empty "$convert_dir"

    local source="$convert_dir/House - 1x01 - Pilot"
    mkdir "$source"
    cp tests/source/tiny.mp4 "$source"
    cp tests/source/tv.jpg "$source/poster.jpg"
    cp tests/source/tv.jpg "$source/poster-resized-4482.jpg"

    media-add-video "$source"

    # source directory moved to trash, without useless resized image file
    [ -d "$MEDIA_TRASH_DIR/House - 1x01 - Pilot" ]
    [ -f "$MEDIA_TRASH_DIR/House - 1x01 - Pilot/tiny.mp4" ]
    [ -f "$MEDIA_TRASH_DIR/House - 1x01 - Pilot/poster.jpg" ]
    [ ! -f "$MEDIA_TRASH_DIR/House - 1x01 - Pilot/poster-resized-4482.jpg" ]

    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]
    dir_is_empty "$convert_dir"

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

@test "doesn't overwrite video" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"

    # copy a file to the expected destination
    local -r install_dir="$MEDIA_TV_BASE/House/Season 1"
    local -r existing="$install_dir/01 Pilot.m4v"
    mkdir -p "$install_dir"
    touch "$existing"

    media-add-video "tests/process/House - 1x01 - Pilot"

    # media-add-video should have installed converted TV
    [ "$( count_files_in_dir "$MEDIA_TV_BASE" )" = 2 ]

    # file is not the output video
    [ "$(count_atoms_in_file "$existing" )" == 0 ]

    local -r installed="$MEDIA_TV_BASE/House/Season 1/01 Pilot.1.m4v"
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

@test "source files can contain spaces" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    local -r process_dir=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$process_dir"

    local -r source_dir="$process_dir/House - 1x01 - Everybody Lies"
    mkdir "$source_dir"
    cp tests/source/tiny.mp4 "$source_dir/source video.mp4"
    cp tests/source/tv.jpg "$source_dir/poster.jpg"

    media-add-video "$source_dir"

    # media-add should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]

    local installed="$MEDIA_TV_BASE/House/Season 1/01 Everybody Lies.m4v"
    [ -f "$installed" ]
    media_lookup_atom "$installed" .
    [ "$( media_lookup_atom "$installed" tvsh )" = 'House' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '1' ]
    [ "$( media_lookup_atom "$installed" tves )" = '1' ]
    [ "$( media_lookup_atom "$installed" tven )" = '1x01' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Everybody Lies' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE
}

@test "metadata overrides directory name for single video file directories" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    local -r process_dir=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$process_dir"

    local -r source_dir="$process_dir/House - 1x01 - Everybody Lies"
    mkdir -p "$source_dir"
    cp tests/source/tiny.mp4 "$source_dir/tiny.mp4"
    cp tests/source/tv.jpg "$source_dir/poster.jpg"
    cp tests/config/episode.conf "$source_dir/metadata.conf"

    media-add-video "$source_dir"

    # media-add should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]

    local installed="$MEDIA_TV_BASE/Buffy the Vampire Slayer/Season 4/09 Something Blue.m4v"
    [ -f "$installed" ]
    media_lookup_atom "$installed" .
    [ "$( media_lookup_atom "$installed" tvsh )" = 'Buffy the Vampire Slayer' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '4' ]
    [ "$( media_lookup_atom "$installed" tves )" = '9' ]
    [ "$( media_lookup_atom "$installed" tven )" = '4x09' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Something Blue' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE
}
