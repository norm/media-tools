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
    local episode="House - 1x01 - Pilot"
    local tempfile=$( mktemp )
    local -a metadata

    cp tests/source/tiny.mp4 "$tempfile"

    eval media-tag-video "$tempfile" $( media-extract-metadata "$episode" )

    # these were the direct arguments
    [ "$(lookup_atom "$tempfile" tvsn)" == '1' ]
    [ "$(lookup_atom "$tempfile" tves)" == '1' ]
    [ "$(lookup_atom "$tempfile" ©nam)" == 'Pilot' ]
    [ "$(lookup_atom "$tempfile" stik)" == 'TV Show' ]
    [ "$(lookup_atom "$tempfile" tvsh)" == 'House' ]

    # this was auto generated, even though not passed as an argument
    [ "$(lookup_atom "$tempfile" tven)" == '1x01' ]

    [ $(AtomicParsley "$tempfile" -t | wc -l ) == 6 ]
}
