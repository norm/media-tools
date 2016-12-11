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

@test "add one poster" {
    local source=$( mktemp )

    cp tests/source/tiny.mp4 "$source"
    [ "$(lookup_atom "$source" covr)" == '' ]

    media-set-poster "$source" tests/source/tv.jpg
    [ "$(lookup_atom "$source" covr)" == '1 piece of artwork' ]

    rm -f "$source"
}

@test "add two posters" {
    local source=$( mktemp )

    cp tests/source/tiny.mp4 "$source"
    [ "$(lookup_atom "$source" covr)" == '' ]

    media-set-poster "$source" tests/source/tv.jpg
    media-set-poster "$source" tests/source/movie.jpg
    [ "$(lookup_atom "$source" covr)" == '2 pieces of artwork' ]

    rm -f "$source"
}
