#!/usr/bin/env bats

source bin/media-convert-video


@test "basic video conversion" {
    local -r input=tests/source/720p-ac3.vob
    local -r track=1
    local -a args=( $(get_handbrake_args "$input" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 0:0:0:0
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --maxWidth 1920
        --maxHeight 1080
        --quality 22
        --x264-preset slow
        --h264-profile high
        --h264-level 4.1
    )

    echo "expected = ${expected[@]}"
    echo "got      = ${args[@]}"
    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}

@test "testing video conversion" {
    export MEDIA_TESTING=1
    local -r input=tests/source/720p-ac3.vob
    local -r track=1
    local -a args=( $(get_handbrake_args "$input" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 0:0:0:0
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --quality 55
        --x264-preset ultrafast
        --h264-profile baseline
    )

    echo "expected = ${expected[@]}"
    echo "got      = ${args[@]}"
    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}

@test "short video conversion" {
    export MEDIA_TESTING=short
    local -r input=tests/source/720p-ac3.vob
    local -r track=1
    local -a args=( $(get_handbrake_args "$input" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 0:0:0:0
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --quality 55
        --x264-preset ultrafast
        --h264-profile baseline
        --chapters 1
        --start-at duration:0
        --stop-at duration:60
    )

    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}

@test "small video conversion" {
    export MEDIA_TESTING=small
    local -r input=tests/source/720p-ac3.vob
    local -r track=1
    local -a args=( $(get_handbrake_args "$input" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 0:0:0:0
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --quality 55
        --x264-preset ultrafast
        --h264-profile baseline
        --maxWidth 320
        --maxHeight 240
    )

    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}

@test "short and small video conversion" {
    export MEDIA_TESTING="short small"
    local -r input=tests/source/720p-ac3.vob
    local -r track=1
    local -a args=( $(get_handbrake_args "$input" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 0:0:0:0
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --quality 55
        --x264-preset ultrafast
        --h264-profile baseline
        --chapters 1
        --start-at duration:0
        --stop-at duration:60
        --maxWidth 320
        --maxHeight 240
    )

    echo "expected = ${expected[@]}"
    echo "got      = ${args[@]}"
    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}
