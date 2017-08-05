#!/usr/bin/env bats

source bin/media
source tests/lib.sh


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

@test "add one poster that triggers resized temp file" {
    local -r source="$( mktemp -d )"
    echo "** source_dir=$source"

    cp tests/source/tiny.mp4 "$source"
    cp tests/inputs/resizes.jpg "$source/cover.jpg"
    [ "$(media_lookup_atom "$source/tiny.mp4" covr)" == '' ]

    # only the files we've copied in
    [ $( count_files_in_dir "$source" ) = 2 ]

    media-set-artwork "$source/tiny.mp4" "$source/cover.jpg"
    [ "$(media_lookup_atom "$source/tiny.mp4" covr)" == '1 piece of artwork' ]

    # only the files we've copied in
    [ $( count_files_in_dir "$source" ) = 2 ]

    rm -rf "$source"
}
