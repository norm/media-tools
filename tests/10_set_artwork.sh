#!/usr/bin/env bats

source bin/media


@test "add one poster" {
    local -r source="$( mktemp )"

    cp tests/source/tiny.mp4 "$source"
    [ "$(media_lookup_atom "$source" covr)" == '' ]

    media-set-artwork "$source" tests/source/tv.jpg
    [ "$(media_lookup_atom "$source" covr)" == '1 piece of artwork' ]

    rm -f "$source"
}

@test "add two posters" {
    local -r source=$( mktemp )

    cp tests/source/tiny.mp4 "$source"
    [ "$(media_lookup_atom "$source" covr)" == '' ]

    media-set-artwork "$source" tests/source/tv.jpg
    media-set-artwork "$source" tests/source/movie.jpg
    [ "$(media_lookup_atom "$source" covr)" == '2 pieces of artwork' ]

    rm -f "$source"
}
