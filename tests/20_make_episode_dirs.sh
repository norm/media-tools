#!/usr/bin/env bats

source bin/media-make-episode-dir
source tests/lib.sh


@test "makes episode directory with global poster image" {
    export MEDIA_TV_BASE=$( mktemp -d )
    local -r process_dir=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$process_dir"

    mkdir "$MEDIA_TV_BASE/posters"
    cp "tests/source/tv.jpg" "$MEDIA_TV_BASE/posters/House.jpg"

    pushd "$process_dir"
    media-make-episode-dir House 1 1

    local -r episode_dir="House - 1x01 - Everybody Lies"
    [ -d "$episode_dir" ]
    [ -f "$episode_dir/poster.jpg" ]
    diff "$episode_dir/poster.jpg" "$MEDIA_TV_BASE/posters/House.jpg"

    popd
    rm -rf "$MEDIA_TV_BASE" "$process_dir"
}

@test "makes episode directory with show image" {
    export MEDIA_TV_BASE=$( mktemp -d )
    local -r process_dir=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$process_dir"

    mkdir "$MEDIA_TV_BASE/posters"
    mkdir "$MEDIA_TV_BASE/House"
    cp "tests/source/movie.jpg" "$MEDIA_TV_BASE/posters/House.jpg"
    cp "tests/source/tv.jpg" "$MEDIA_TV_BASE/House/poster.jpg"

    pushd $process_dir
    media-make-episode-dir House 1 1

    local -r episode_dir="House - 1x01 - Everybody Lies"
    [ -d "$episode_dir" ]
    [ -f "$episode_dir/poster.jpg" ]
    diff "$episode_dir/poster.jpg" "$MEDIA_TV_BASE/House/poster.jpg"

    popd
    rm -rf "$MEDIA_TV_BASE" "$process_dir"
}

@test "makes episode directory with season image" {
    export MEDIA_TV_BASE=$( mktemp -d )
    local -r process_dir=$( mktemp -d )

    # there should be nothing before we begin
    dir_is_empty "$MEDIA_TV_BASE"
    dir_is_empty "$process_dir"

    mkdir "$MEDIA_TV_BASE/posters"
    mkdir "$MEDIA_TV_BASE/House"
    mkdir "$MEDIA_TV_BASE/House/Season 1"
    cp "tests/source/movie.jpg" "$MEDIA_TV_BASE/posters/House.jpg"
    cp "tests/source/movie.jpg" "$MEDIA_TV_BASE/House/poster.jpg"
    cp "tests/source/tv.jpg" "$MEDIA_TV_BASE/House/Season 1/poster.jpg"

    pushd $process_dir
    media-make-episode-dir House 1 1

    local -r episode_dir="House - 1x01 - Everybody Lies"
    [ -d "$episode_dir" ]
    [ -f "$episode_dir/poster.jpg" ]
    diff "$episode_dir/poster.jpg" "$MEDIA_TV_BASE/House/Season 1/poster.jpg"

    popd
    rm -rf "$MEDIA_TV_BASE" "$process_dir"
}

@test "doesn't make directories with invalid metacharacters" {
    local check=$( sanitise_for_directory 'Show - 1x01 - Thing/Other Thing')
    [ 'Show - 1x01 - Thing - Other Thing' == "$check" ]

    local check=$( sanitise_for_directory 'Show - 1x01 - Thing:Other Thing')
    [ 'Show - 1x01 - Thing - Other Thing' == "$check" ]
}
