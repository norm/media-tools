#!/usr/bin/env bats

function setup {
    OUTPUT_FILE=$( mktemp )
    SOURCE_METADATA=$( mktemp )
    OUTPUT_METADATA=$( mktemp )
}

function teardown {
    rm -f "$VIDEO_OUTPUT"  "$SOURCE_METADATA" "$OUTPUT_METADATA"
}

function get_video_metadata {
    HandBrakeCLI -i "$SOURCE_FILE" -t0 > "$SOURCE_METADATA" 2>&1
    HandBrakeCLI -i "$OUTPUT_FILE" -t0 > "$OUTPUT_METADATA" 2>&1
}

function compare_output_size {
    local source_fact
    local output_fact

    # conversion should keep size intact
    source_fact=$( awk '/size/ { print $3 }' "$SOURCE_METADATA" )
    output_fact=$( awk '/size/ { print $3 }' "$OUTPUT_METADATA" )
    echo "source_fact='$source_fact'"
    echo "output_fact='$output_fact'"
    [ -n "$source_fact" -a "$source_fact" == "$output_fact" ]
}

function compare_output_duration {
    local source_fact
    local output_fact

    # conversion should keep duration intact
    source_fact=$( awk '/duration/ { print $3 }' "$SOURCE_METADATA" )
    output_fact=$( awk '/duration/ { print $3 }' "$OUTPUT_METADATA" )
    echo "source_fact='$source_fact'"
    echo "output_fact='$output_fact'"
    [ -n "$source_fact" -a "$source_fact" == "$output_fact" ]
}


@test "converts 720p AC3" {
    SOURCE_FILE="tests/source/720p-ac3.vob"

    run media-convert-video "$SOURCE_FILE" "$OUTPUT_FILE"
    get_video_metadata
    compare_output_size
    compare_output_duration
}
