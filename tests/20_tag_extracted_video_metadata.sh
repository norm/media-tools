#!/usr/bin/env bats

source bin/media


@test "adds tags to video files" {
    local -r episode="House - 1x01 - Pilot"
    local -r tempfile=$( mktemp )
    local -a metadata

    cp tests/source/tiny.mp4 "$tempfile"

    eval media-tag-video "$tempfile" $( media-extract-video-metadata "$episode" )

    # these were the direct arguments
    [ "$(media_lookup_atom "$tempfile" tvsn)" == '1' ]
    [ "$(media_lookup_atom "$tempfile" tves)" == '1' ]
    [ "$(media_lookup_atom "$tempfile" ©nam)" == 'Pilot' ]
    [ "$(media_lookup_atom "$tempfile" stik)" == 'TV Show' ]
    [ "$(media_lookup_atom "$tempfile" tvsh)" == 'House' ]

    # this was auto generated, even though not passed as an argument
    [ "$(media_lookup_atom "$tempfile" tven)" == '1x01' ]

    [ $(AtomicParsley "$tempfile" -t | wc -l ) == 6 ]
}
