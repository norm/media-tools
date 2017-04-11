#!/usr/bin/env bats

source bin/media
source tests/lib.sh


@test "adds tags to video files" {
    local -r tempfile=$( mktemp )
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

    [ "$(count_atoms_in_file "$tempfile" )" == 5 ]
}

@test "adds tags to extended video files" {
    local -r tempfile=$( mktemp )
    local -a metadata

    cp tests/source/tiny.mp4 "$tempfile"
    media-tag-video                         \
        "$tempfile"                         \
        --TVShowName='Brooklyn Nine-Nine'   \
        --TVEpisodeNum=11-12                \
        --TVSeasonNum=4                     \
        --title='Fugitive'

    # these were the direct arguments
    [ "$(media_lookup_atom "$tempfile" tvsn)" == '4' ]
    [ "$(media_lookup_atom "$tempfile" ©nam)" == 'Fugitive' ]
    [ "$(media_lookup_atom "$tempfile" tvsh)" == 'Brooklyn Nine-Nine' ]

    # this was auto truncated by AtomicParsley
    [ "$(media_lookup_atom "$tempfile" tves)" == '11' ]

    # this was auto generated, even though not passed as an argument
    [ "$(media_lookup_atom "$tempfile" tven)" == '4x11-12' ]

    # this is not automatically applied, even though it could be deduced
    [ "$(media_lookup_atom "$tempfile" stik)" == '' ]

    [ "$(count_atoms_in_file "$tempfile" )" == 5 ]
}
