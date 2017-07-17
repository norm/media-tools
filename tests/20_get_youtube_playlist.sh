#!/usr/bin/env bats

source tests/lib.sh

PLAYLIST=PL4zR2yLTCZ8chNFr0T_5EYzbCuNwaSRgO


@test "downloads the three videos in YouTube playlist" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CACHE_DIR"
    dir_is_empty "$MEDIA_CONVERT_DIR"

    local -r cache_dir="$MEDIA_CACHE_DIR/$PLAYLIST"
    local -r convert_dir="$MEDIA_CONVERT_DIR/$PLAYLIST"

    media-get-youtube-playlist $PLAYLIST

    [ $( count_files_in_dir "$MEDIA_CACHE_DIR" ) = 6 ]
    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 9 ]
    [ -f "$cache_dir/playlist.json" ]
    [ -f "$cache_dir/season_2010.count" ]
    [ -f "$cache_dir/season_2012.count" ]

    # each video in the playlist has...
    for video in "${VIDEOS[@]}"; do
        # source files suitable for converting,
        [ -f "$convert_dir/$video/$video.mp4" ]
        [ -f "$convert_dir/$video/metadata.conf" ]
        [ -f "$convert_dir/$video/poster.jpg" ]

        grep -q 'series = media-tools testing' \
            "$convert_dir/$video/metadata.conf"

        # and the original fetch JSON metadata stored for later use
        [ -f "$cache_dir/$video.info.json" ]
    done

    grep -q 'season = 2010' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'season = 2012' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'season = 2012' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'episode = 02' "$convert_dir/ppqiWVaO3rg/metadata.conf"

    rm -rf "$MEDIA_CACHE_DIR" "$MEDIA_CONVERT_DIR"
}

@test "downloads the three videos in YouTube playlist in reverse order" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CACHE_DIR"
    dir_is_empty "$MEDIA_CONVERT_DIR"

    local -r cache_dir="$MEDIA_CACHE_DIR/$PLAYLIST"
    local -r convert_dir="$MEDIA_CONVERT_DIR/$PLAYLIST"

    media-get-youtube-playlist --reversed $PLAYLIST

    [ $( count_files_in_dir "$MEDIA_CACHE_DIR" ) = 6 ]
    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 9 ]
    [ -f "$cache_dir/playlist.json" ]
    [ -f "$cache_dir/season_2010.count" ]
    [ -f "$cache_dir/season_2012.count" ]

    # each video in the playlist has...
    for video in "${VIDEOS[@]}"; do
        # source files suitable for converting,
        [ -f "$convert_dir/$video/$video.mp4" ]
        [ -f "$convert_dir/$video/metadata.conf" ]
        [ -f "$convert_dir/$video/poster.jpg" ]

        grep -q 'series = media-tools testing' \
            "$convert_dir/$video/metadata.conf"

        # and the original fetch JSON metadata stored for later use
        [ -f "$cache_dir/$video.info.json" ]
    done

    # ppqiWVaO3rg is now the first 2012 video, not the second
    grep -q 'season = 2010' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'season = 2012' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'season = 2012' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'episode = 02' "$convert_dir/EyI-5e1IrEo/metadata.conf"

    rm -rf "$MEDIA_CACHE_DIR" "$MEDIA_CONVERT_DIR"
}

@test "downloads the three videos as one season" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CACHE_DIR"
    dir_is_empty "$MEDIA_CONVERT_DIR"

    local -r cache_dir="$MEDIA_CACHE_DIR/$PLAYLIST"
    local -r convert_dir="$MEDIA_CONVERT_DIR/$PLAYLIST"

    media-get-youtube-playlist --reversed --season 1 $PLAYLIST

    [ $( count_files_in_dir "$MEDIA_CACHE_DIR" ) = 5 ]
    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 9 ]
    [ -f "$cache_dir/playlist.json" ]
    [ -f "$cache_dir/season_1.count" ]

    # each video in the playlist has...
    for video in "${VIDEOS[@]}"; do
        # source files suitable for converting,
        [ -f "$convert_dir/$video/$video.mp4" ]
        [ -f "$convert_dir/$video/metadata.conf" ]
        [ -f "$convert_dir/$video/poster.jpg" ]

        grep -q 'series = media-tools testing' \
            "$convert_dir/$video/metadata.conf"

        # and the original fetch JSON metadata stored for later use
        [ -f "$cache_dir/$video.info.json" ]
    done

    grep -q 'season = 1' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'season = 1' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'episode = 02' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'season = 1' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'episode = 03' "$convert_dir/BE7gAEsI0XY/metadata.conf"

    rm -rf "$MEDIA_CACHE_DIR" "$MEDIA_CONVERT_DIR"
}

@test "downloads with a custom title and poster images" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )
    export MEDIA_TV_BASE=$( mktemp -d )

    dir_is_empty "$MEDIA_CACHE_DIR"
    dir_is_empty "$MEDIA_CONVERT_DIR"
    dir_is_empty "$MEDIA_TV_BASE"

    local -r cache_dir="$MEDIA_CACHE_DIR/$PLAYLIST"
    local -r convert_dir="$MEDIA_CONVERT_DIR/$PLAYLIST"

    mkdir -p "$MEDIA_TV_BASE/Testing Playlist/Season 1"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/Testing Playlist/Season 1/poster.jpg"

    echo MEDIA_TV_BASE=$MEDIA_TV_BASE

    media-get-youtube-playlist \
        --title 'Testing Playlist' \
        --reversed \
        --season 1 \
            $PLAYLIST

    [ $( count_files_in_dir "$MEDIA_CACHE_DIR" ) = 5 ]
    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 9 ]
    [ -f "$cache_dir/playlist.json" ]
    [ -f "$cache_dir/season_1.count" ]

    # each video in the playlist has...
    for video in "${VIDEOS[@]}"; do
        # source files suitable for converting,
        [ -f "$convert_dir/$video/$video.mp4" ]
        [ -f "$convert_dir/$video/metadata.conf" ]
        [ -f "$convert_dir/$video/poster.jpg" ]
        diff "$convert_dir/$video/poster.jpg" tests/source/tv.jpg

        grep -q 'series = Testing Playlist' \
            "$convert_dir/$video/metadata.conf"

        # and the original fetch JSON metadata stored for later use
        [ -f "$cache_dir/$video.info.json" ]
    done

    grep -q 'season = 1' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'episode = 01' "$convert_dir/ppqiWVaO3rg/metadata.conf"
    grep -q 'season = 1' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'episode = 02' "$convert_dir/EyI-5e1IrEo/metadata.conf"
    grep -q 'season = 1' "$convert_dir/BE7gAEsI0XY/metadata.conf"
    grep -q 'episode = 03' "$convert_dir/BE7gAEsI0XY/metadata.conf"

    rm -rf "$MEDIA_CACHE_DIR" "$MEDIA_CONVERT_DIR" "$MEDIA_TV_BASE"
}

@test "downloads nothing when cached files exist" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CACHE_DIR"
    dir_is_empty "$MEDIA_CONVERT_DIR"

    local -r cache_dir="$MEDIA_CACHE_DIR/$PLAYLIST"
    local -r convert_dir="$MEDIA_CONVERT_DIR/$PLAYLIST"
    mkdir -p "$cache_dir"

    # create the cached playlist information files
    mkdir -p "$cache_dir"
    for video in "${VIDEOS[@]}"; do
        touch "$cache_dir/$video.info.json"
    done

    # since everything has been fetched previously,
    # nothing needs to be fetched now
    media-get-youtube-playlist $PLAYLIST
    dir_is_empty "$MEDIA_CONVERT_DIR"

    media-get-youtube-playlist --reversed $PLAYLIST
    dir_is_empty "$MEDIA_CONVERT_DIR"
}

@test "adds videos to iTunes" {
    declare -a VIDEOS=(
        ppqiWVaO3rg
        EyI-5e1IrEo
        BE7gAEsI0XY
    )

    export MEDIA_CACHE_DIR=$( mktemp -d )
    export MEDIA_CONVERT_DIR=$( mktemp -d )
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TV_BASE=$( mktemp -d )

    dir_is_empty "$MEDIA_TV_BASE"

    media-get-youtube-playlist --add $PLAYLIST

    # media-add-video should have installed converted TV
    [ $( count_files_in_dir "$MEDIA_TV_BASE" ) = 3 ]

    local -r series_dir="$MEDIA_TV_BASE/media-tools testing"
    [ -f "$series_dir/Season 2010/01 Grange Hill 1978 intro (HQ).m4v" ]
    [ -f "$series_dir/Season 2012/01 Doctor Who opening theme Peter Davison (5th Doctor).m4v" ]
    [ -f "$series_dir/Season 2012/02 Doctor Who Clean Tom Baker Opening 1980-81 (Higher Quality).m4v" ]

    rm -rf "$MEDIA_CACHE_DIR" "$MEDIA_CONVERT_DIR" "$MEDIA_TV_BASE"
}
