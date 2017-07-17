#!/usr/bin/env bats

source tests/lib.sh


@test "downloads YouTube video" {
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CONVERT_DIR"

    media-get-youtube-video BE7gAEsI0XY

    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 3 ]
    [ -f "$MEDIA_CONVERT_DIR/BE7gAEsI0XY/BE7gAEsI0XY.mp4" ]
    [ -f "$MEDIA_CONVERT_DIR/BE7gAEsI0XY/BE7gAEsI0XY.info.json" ]
    [ -f "$MEDIA_CONVERT_DIR/BE7gAEsI0XY/poster.jpg" ]
}

@test "downloads YouTube video into playlist directory" {
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CONVERT_DIR"

    media-get-youtube-video \
        BE7gAEsI0XY \
        FLhCfyxtJP1e4eO0v7L1CUJw

    local -r dir="$MEDIA_CONVERT_DIR/FLhCfyxtJP1e4eO0v7L1CUJw/BE7gAEsI0XY"

    [ $( count_files_in_dir "$MEDIA_CONVERT_DIR" ) = 3 ]
    [ -f "$dir/BE7gAEsI0XY.mp4" ]
    [ -f "$dir/BE7gAEsI0XY.info.json" ]
    [ -f "$dir/poster.jpg" ]
}

@test "cleans up directories after an unavailable video" {
    export MEDIA_CONVERT_DIR=$( mktemp -d )

    dir_is_empty "$MEDIA_CONVERT_DIR"
    touch "$MEDIA_CONVERT_DIR/preserve.txt"

    media-get-youtube-video \
        X58g1HKxXPo \
        FLhCfyxtJP1e4eO0v7L1CUJw || true

    find $MEDIA_CONVERT_DIR

    # no playlist directory exists
    [ ! -d "$MEDIA_CONVERT_DIR/FLhCfyxtJP1e4eO0v7L1CUJw/X58g1HKxXPo" ]
}
