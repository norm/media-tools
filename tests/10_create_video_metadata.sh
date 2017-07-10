#!/usr/bin/env bats

source tests/lib.sh


@test "test metadata from a single video file" {
    OUTPUT_FILE=$( mktemp )

    media-create-video-metadata tests/source/720p-ac3.vob > $OUTPUT_FILE
    diff -u $OUTPUT_FILE tests/config/unedited-file.conf
}

@test "test metadata from a DVD" {
    needs_source tests/source/BUFFY_S4D3

    OUTPUT_FILE=$( mktemp )

    media-create-video-metadata tests/source/BUFFY_S4D3 > $OUTPUT_FILE
    diff -u $OUTPUT_FILE tests/config/buffy_s4d3_unedited.conf
}
