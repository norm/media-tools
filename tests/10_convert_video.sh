#!/usr/bin/env bats

source bin/media
export MEDIA_TESTING=1


function setup {
    OUTPUT_FILE=$( mktemp )
    SOURCE_METADATA=$( mktemp )
    OUTPUT_METADATA=$( mktemp )
}

function teardown {
    rm -f "$VIDEO_OUTPUT"  "$SOURCE_METADATA" "$OUTPUT_METADATA"
}

function capture_metadata {
    HandBrakeCLI -i "$SOURCE_FILE" -t0 > "$SOURCE_METADATA" 2>&1
    HandBrakeCLI -i "$OUTPUT_FILE" -t0 > "$OUTPUT_METADATA" 2>&1
}

function compare_metadata_fact {
    local fact="$1"

    local -r source_fact=$(
        cat "$SOURCE_METADATA" \
            | extract_track_metadata "$TRACK" \
            | awk "/$fact/"' { print $3 }'
    )
    local -r output_fact=$(
        cat "$OUTPUT_METADATA" \
            | extract_track_metadata 1 \
            | awk "/$fact/"' { print $3 }'
    )

    echo "source_fact=$source_fact"
    echo "output_fact=$output_fact"
    [ -n "$source_fact" -a "$source_fact" == "$output_fact" ]
}

function compare_audio_tracks {
    local -r source_tracks=$(
        cat "$SOURCE_METADATA" \
            | extract_track_metadata "$TRACK" \
            | extract_audio_tracks
    )
    local -r output_tracks=$(
        cat "$OUTPUT_METADATA" \
            | extract_track_metadata 1 \
            | extract_audio_tracks
    )

    [ "$source_tracks" == "$output_tracks" ]
}


@test "converts 720p AC3" {
    SOURCE_FILE="tests/source/720p-ac3.vob"
    TRACK=1

    run media-convert-video "$SOURCE_FILE" "$OUTPUT_FILE" "$TRACK"
    capture_metadata
    compare_metadata_fact 'size'
    compare_metadata_fact 'duration'
    compare_audio_tracks
}

@test "converts one track in a DVD" {
    SOURCE_FILE="tests/source/BUFFY_S4D3"
    TRACK=19

    run media-convert-video "$SOURCE_FILE" "$OUTPUT_FILE" "$TRACK"
    capture_metadata
    compare_metadata_fact 'size'
    compare_metadata_fact 'duration'
    compare_audio_tracks
}
