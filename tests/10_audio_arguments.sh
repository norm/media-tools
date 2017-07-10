#!/usr/bin/env bats

source bin/media-convert-video
source tests/lib.sh


@test "passthrough AC3" {
    local -a args=($( get_audio_arguments "tests/source/720p-ac3.vob" ))
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = '6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = 'Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'copy:ac3' ]
}

@test "passthrough DTS" {
    local -a args=($( get_audio_arguments "tests/source/sd-dts.vob" ))
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = '6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = 'Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'copy:dts' ]
}

@test "passthrough AAC" {
    local -a args=($( get_audio_arguments "tests/source/aac.mp4" ))
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = '6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = 'Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'copy:aac' ]
}

@test "convert MP3 to AAC" {
    local -a args=($( get_audio_arguments "tests/source/mp3.divx" ))
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '160' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = 'stereo' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = '48' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'ca_aac' ]
}

@test "multiple streams" {
    local -a args=($( get_audio_arguments "tests/source/multiple.divx" ))
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1,2' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '160,640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = 'stereo,6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = '48,Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'ca_aac,copy:ac3' ]
}

@test "only one title from a DVD" {
    needs_source tests/source/BUFFY_S4D3

    local -a args=($( get_audio_arguments "tests/source/BUFFY_S4D3" 1 ))
    echo "${args[@]}"
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = '6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = 'Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'copy:ac3' ]
}

@test "a DVD title with multiple audio streams" {
    needs_source tests/source/BUFFY_S4D3

    local -a args=($( get_audio_arguments "tests/source/BUFFY_S4D3" 2 ))
    echo "${args[@]}"
    [ "${args[0]}" = '--audio' ]
    [ "${args[1]}" = '1,2' ]
    [ "${args[2]}" = '--ab' ]
    [ "${args[3]}" = '640,640' ]
    [ "${args[4]}" = '--mixdown' ]
    [ "${args[5]}" = '6ch,6ch' ]
    [ "${args[6]}" = '--arate' ]
    [ "${args[7]}" = 'Auto,Auto' ]
    [ "${args[8]}" = '--aencoder' ]
    [ "${args[9]}" = 'copy:ac3,copy:ac3' ]
}

@test "default VIDEO_LANG includes multiple languages" {
    needs_source tests/source/multiple-langs.mkv

    local -a expects=(
        '--audio 1,2'
        '--ab 640,640'
        '--mixdown 6ch,6ch'
        '--arate Auto,Auto'
        '--aencoder copy:ac3,copy:ac3'
    )

    get_audio_arguments tests/source/multiple-langs.mkv
    run get_audio_arguments tests/source/multiple-langs.mkv

    local count=0
    for line in "${expects[@]}"; do
        echo "-> ${expects[count]}"
        echo "   ${lines[count]}"
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "setting VIDEO_LANG excludes unmatching languages" {
    needs_source tests/source/multiple-langs.mkv

    local -a expects=(
        '--audio 2'
        '--ab 640'
        '--mixdown 6ch'
        '--arate Auto'
        '--aencoder copy:ac3'
    )

    export MEDIA_VIDEO_LANG=eng
    source bin/media-convert-video

    get_audio_arguments tests/source/multiple-langs.mkv
    run get_audio_arguments tests/source/multiple-langs.mkv

    local count=0
    for line in "${expects[@]}"; do
        echo "-> ${expects[count]}"
        echo "   ${lines[count]}"
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "setting VIDEO_LANG includes unknown languages" {
    local -a expects=(
        '--audio 1,2'
        '--ab 160,640'
        '--mixdown stereo,6ch'
        '--arate 48,Auto'
        '--aencoder ca_aac,copy:ac3'
    )

    export MEDIA_VIDEO_LANG=eng
    source bin/media-convert-video

    get_audio_arguments tests/source/multiple.divx
    run get_audio_arguments tests/source/multiple.divx

    local count=0
    for line in "${expects[@]}"; do
        echo "-> ${expects[count]}"
        echo "   ${lines[count]}"
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}
