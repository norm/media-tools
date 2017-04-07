#!/usr/bin/env bats

source bin/media
source tests/lib.sh

DVD_IMAGE='tests/source/BUFFY_S4D3'
CONF="$DVD_IMAGE/metadata.conf"
UNEDITED_CONF="tests/config/buffy_s4d3_unedited.conf"
EDITED_CONF="tests/config/buffy_s4d3.conf"
POSTER="$DVD_IMAGE/poster.jpg"


@test "empty DVD image creates a metadata.conf" {
    rm -f "$CONF"
    media-add "$DVD_IMAGE"

    [ -f "$CONF" ]
    diff -u "$CONF" "$UNEDITED_CONF"
}

@test "refuses to add titles unless metadata.conf has been filled out" {
    cp "$UNEDITED_CONF" "$CONF"

    run media-add "$DVD_IMAGE"
    [ "$output" == "'$DVD_IMAGE/metadata.conf' has not been filled out; aborting." ]
}

@test "ignores REPLACE_ME tokens that are commented out" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short
    TRACK=1

    cp "$EDITED_CONF" "$CONF"

    run media-add -t$TRACK "$DVD_IMAGE"
    [ "$output" != "'$DVD_IMAGE/metadata.conf' has not been filled out; aborting." ]
}

@test "add a single title from a multi-title DVD" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short
    TRACK=1

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    echo "** $MEDIA_TV_BASE"

    cp "$EDITED_CONF" "$CONF"
    cp tests/source/tv.jpg "$POSTER"
    media-add -t$TRACK "$DVD_IMAGE"

    # media-add should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 1 ]

    local installed="$MEDIA_TV_BASE/Buffy the Vampire Slayer/Season 4/09 Something Blue.m4v"
    [ -f "$installed" ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'Buffy the Vampire Slayer' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '4' ]
    [ "$( media_lookup_atom "$installed" tves )" = '9' ]
    [ "$( media_lookup_atom "$installed" tven )" = '4x09' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Something Blue' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE
}

@test "adds all titles from a multi-title DVD" {
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"

    cp "$EDITED_CONF" "$CONF"
    cp tests/source/tv.jpg "$POSTER"
    media-add "$DVD_IMAGE"

    # media-add should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 9 ]

    local install_dir="$MEDIA_TV_BASE/Buffy the Vampire Slayer/Season 4/"
    local installed="$install_dir/09 Something Blue.m4v"
    [ -f "$installed" ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'Buffy the Vampire Slayer' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '4' ]
    [ "$( media_lookup_atom "$installed" tves )" = '9' ]
    [ "$( media_lookup_atom "$installed" tven )" = '4x09' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Something Blue' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    [ -f "$install_dir/10 Hush.m4v" ]
    [ -f "$install_dir/11 Doomed.m4v" ]
    [ -f "$install_dir/101 Hush Featurette.m4v" ]
    [ -f "$install_dir/102 The Sets of Sunnydale.m4v" ]
    [ -f "$install_dir/103 Spike, Me.m4v" ]
    [ -f "$install_dir/104 Inside the Music.m4v" ]
    [ -f "$install_dir/106 Season 2 DVD Trailer.m4v" ]
    [ -f "$install_dir/107 Season 3 DVD Trailer.m4v" ]

    rm -rf $MEDIA_TV_BASE
}
