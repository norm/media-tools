#!/usr/bin/env bats

function lookup_atom {
    local file="$1"
    local atom="$2"

    # the perl invocation removes a unicode byte order mark character, which
    # is probably useful, but makes it really hard to grep things consistently
    AtomicParsley "$file" -t                \
        | perl -ne 's/^[^A]+//m; print;'    \
        | grep "Atom .${atom}."             \
        | cut -c23-
}

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
    [ "$(lookup_atom "$tempfile" tvsn)" == '1' ]
    [ "$(lookup_atom "$tempfile" tves)" == '1' ]
    [ "$(lookup_atom "$tempfile" ©nam)" == 'Pilot' ]
    [ "$(lookup_atom "$tempfile" tvsh)" == 'House' ]

    # this was auto generated, even though not passed as an argument
    [ "$(lookup_atom "$tempfile" tven)" == '1x01' ]

    # this is not automatically applied, even though it could be deduced
    [ "$(lookup_atom "$tempfile" stik)" == '' ]

    [ $(AtomicParsley "$tempfile" -t | wc -l ) == 5 ]
}
