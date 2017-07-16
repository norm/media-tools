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
