#!/usr/bin/env bats

function test_install_works {
    local -r title="$1"
    local -r destination="$2"
    local -r source="$( mktemp )"

    cp tests/source/tiny.mp4 "$source"

    eval media-tag-video "$source" "$( media-extract-metadata "$title" )"
    media-install "$source"

    [ -f "$destination" ]
    [ ! -f "$source" ]
}

@test "installs a TV show" {
    export MEDIA_TV_BASE="$( mktemp -d )"

    test_install_works              \
        "House - 1x01 - Pilot"      \
        "$MEDIA_TV_BASE/House/Season 1/01 Pilot.m4v"

    rm -rf "$MEDIA_TV_BASE"
}

@test "installs a TV show with quotes" {
    export MEDIA_TV_BASE="$( mktemp -d )"

    test_install_works                                      \
        "Grey's Anatomy - 2x11 - Owner of a Lonely Heart"   \
        "$MEDIA_TV_BASE/Grey's Anatomy/Season 2/11 Owner of a Lonely Heart.m4v"

    rm -rf "$MEDIA_TV_BASE"
}
