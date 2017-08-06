#!/usr/bin/env bats

source bin/media
source tests/lib.sh

DVD_IMAGE='tests/source/BUFFY_S4D3'
CONF="$DVD_IMAGE/metadata.conf"
UNEDITED_CONF="tests/config/buffy_s4d3_unedited.conf"
EDITED_CONF="tests/config/buffy_s4d3.conf"
POSTER="$DVD_IMAGE/poster.jpg"

DVD_MOVIE_IMAGE='tests/source/THE_THIN_MAN'
EDITED_MOVIE_CONF="tests/config/the_thin_man.conf"
MOVIE_CONF="$DVD_MOVIE_IMAGE/metadata.conf"
MOVIE_POSTER="$DVD_MOVIE_IMAGE/poster.jpg"


@test "empty DVD image creates a metadata.conf" {
    needs_source "$DVD_IMAGE"

    rm -f "$CONF"
    media-add-video "$DVD_IMAGE"

    [ -f "$CONF" ]
    diff -u "$CONF" "$UNEDITED_CONF"
}

@test "refuses to add titles unless metadata.conf has been filled out" {
    needs_source "$DVD_IMAGE"

    cp "$UNEDITED_CONF" "$CONF"

    run media-add-video "$DVD_IMAGE"
    [ "$output" == "'$DVD_IMAGE/metadata.conf' has not been filled out; aborting." ]
}

@test "ignores REPLACE_ME tokens that are commented out" {
    needs_source "$DVD_IMAGE"

    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short
    TRACK=1

    cp "$EDITED_CONF" "$CONF"

    run media-add-video -t$TRACK "$DVD_IMAGE"
    [ "$output" != "'$DVD_IMAGE/metadata.conf' has not been filled out; aborting." ]
}

@test "add a single title from a multi-title DVD" {
    needs_source "$DVD_IMAGE"

    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short
    TRACK=1

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    echo "** $MEDIA_TV_BASE"

    cp "$EDITED_CONF" "$CONF"
    cp tests/source/tv.jpg "$POSTER"
    media-add-video -t$TRACK "$DVD_IMAGE"

    # media-add-video should have installed converted TV
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
    needs_source "$DVD_IMAGE"

    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )
    export MEDIA_TESTING=short

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"

    cp "$EDITED_CONF" "$CONF"
    cp tests/source/tv.jpg "$POSTER"
    media-add-video "$DVD_IMAGE"

    # media-add-video should have installed converted TV
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

    # test metadata setting of maxWidth/maxHeight
    local -r size=$(
        HandBrakeCLI -t0 -i "$install_dir/101 Hush Featurette.m4v" \
            2>&1 \
            | extract_track_metadata 1 \
            | awk '/size/ { print $3 }'
    )
    echo "** $size should be 300x240"
    [ "$size" = "300x240," ]

    rm -rf $MEDIA_TV_BASE
}

@test "adds movie titles and extras to movies dir not TV" {
    needs_source "$DVD_MOVIE_IMAGE"

    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_MOVIE_BASE=$( mktemp -d )
    export MEDIA_TESTING=short
    echo "** $MEDIA_MOVIE_BASE"

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_MOVIE_BASE"

    cp "$EDITED_MOVIE_CONF" "$MOVIE_CONF"
    cp tests/source/movie.jpg "$MOVIE_POSTER"
    media-add-video "$DVD_MOVIE_IMAGE"

    # media-add-video should have installed converted movie
    [ $( count_files_in_dir "$MEDIA_MOVIE_BASE" ) = 2 ]

    local install_dir="$MEDIA_MOVIE_BASE/All/The Thin Man"
    echo "install_dir=$install_dir"
    [ -d "$install_dir" ]

    local installed="${install_dir}/The Thin Man - 1934 U.m4v"
    echo "installed=$installed"
    [ -f "$installed" ]

    [ "$( media_lookup_atom "$installed" ©nam )"   = 'The Thin Man' ]
    [ "$( media_lookup_atom "$installed" ©alb )"   = 'The Thin Man' ]
    [ "$( media_lookup_atom "$installed" ©day )"   = '1934' ]
    [ "$( media_lookup_rating_atom "$installed" )" = 'uk-movie|U|100|' ]
    [ "$( media_lookup_atom "$installed" stik )"   = 'Movie' ]
    [ "$( media_lookup_atom "$installed" covr )"   = '1 piece of artwork' ]

    installed="${install_dir}/Extra - The Thin Man Trailer.m4v"
    echo "$installed"
    [ -f "$installed" ]

    [ "$( media_lookup_atom "$installed" ©nam )"   = 'The Thin Man Trailer' ]
    [ "$( media_lookup_atom "$installed" ©alb )"   = 'The Thin Man' ]
    [ "$( media_lookup_atom "$installed" ©day )"   = '1934' ]
    [ "$( media_lookup_rating_atom "$installed" )" = 'uk-movie|U|100|' ]
    [ "$( media_lookup_atom "$installed" stik )"   = 'Movie' ]
    [ "$( media_lookup_atom "$installed" covr )"   = '1 piece of artwork' ]

    rm -rf $MEDIA_MOVIE_BASE
}
