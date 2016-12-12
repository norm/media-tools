#!/usr/bin/env bats

source bin/media-convert-video

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
