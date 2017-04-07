#!/usr/bin/env bats

@test "test metadata from a single video file" {
    OUTPUT_FILE=$( mktemp )

    media-create-metadata-file tests/source/720p-ac3.vob > $OUTPUT_FILE
    diff -u $OUTPUT_FILE tests/config/unedited-file.conf
}
