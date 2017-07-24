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

@test "override settings in metadata" {
    local -r input_dir=$( mktemp -d )
    local -r track=1

    cp tests/source/720p-ac3.vob "$input_dir"
    cat > "$input_dir/metadata.conf" <<EOF
maxWidth = 1280
maxHeight = 720
crop = 10:10:10:10
EOF

    local -a args=( $(get_handbrake_args "$input_dir/720p-ac3.vob" "$track") )

    local -ar expected=(
        --audio 1
        --ab 640
        --mixdown 6ch
        --arate Auto
        --aencoder copy:ac3
        --loose-anamorphic
        --modulus 2
        --crop 10:10:10:10
        --decomb fast
        --rate 30
        --pfr
        --format mp4
        --encoder x264
        --encopts b-adapt=2
        --markers
        --maxWidth 1280
        --maxHeight 720
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

@test "override settings in DVD metadata" {
    cp tests/config/buffy_s4d3.conf tests/source/BUFFY_S4D3/metadata.conf

    local -a args=( $(get_handbrake_args tests/source/BUFFY_S4D3 19) )

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
        --maxWidth 320
        --maxHeight 240
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

    rm tests/source/BUFFY_S4D3/metadata.conf
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
        --maxWidth 1920
        --maxHeight 1080
        --quality 55
        --x264-preset ultrafast
        --h264-profile baseline
        --chapters 1
        --start-at duration:0
        --stop-at duration:60
    )

    echo "expected = ${expected[@]}"
    echo "got      = ${args[@]}"
    for i in $(seq 0 "${#expected[@]}"); do
        [ "${expected[$i]}" == "${args[$i]}" ]
    done
}
