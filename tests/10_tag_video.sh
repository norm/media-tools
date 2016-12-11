#!/usr/bin/env bats

source bin/media


@test "adds tags to video files" {
    local tempfile=$( mktemp )
    local -a metadata

    cp tests/source/tiny.mp4 "$tempfile"
    media-tag-video             \
        "$tempfile"             \
        --TVShowName='House'    \
        --TVEpisodeNum=1        \
        --TVSeasonNum=1         \
        --title='Pilot'

    # these were the direct arguments
    [ "$(media_lookup_atom "$tempfile" tvsn)" == '1' ]
    [ "$(media_lookup_atom "$tempfile" tves)" == '1' ]
    [ "$(media_lookup_atom "$tempfile" ©nam)" == 'Pilot' ]
    [ "$(media_lookup_atom "$tempfile" tvsh)" == 'House' ]

    # this was auto generated, even though not passed as an argument
    [ "$(media_lookup_atom "$tempfile" tven)" == '1x01' ]

    # this is not automatically applied, even though it could be deduced
    [ "$(media_lookup_atom "$tempfile" stik)" == '' ]

    [ $(AtomicParsley "$tempfile" -t | wc -l ) == 5 ]
}
