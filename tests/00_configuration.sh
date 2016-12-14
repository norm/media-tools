#!/usr/bin/env bats

@test "default configuration" {
    run media show-config
    [ "${lines[0]}" = "CONVERT_DIR=/tmp" ]
    [ "${lines[1]}" = "TRASH_DIR=" ]
    [ "${lines[2]}" = "TV_BASE=/files/tv" ]
}

@test "file overrides default configuration" {
    export MEDIA_CONFIG=tests/config/media.conf

    run media show-config
    [ "${lines[0]}" = "CONVERT_DIR=/tmp/convert" ]
    [ "${lines[1]}" = "TRASH_DIR=/tmp/trash" ]
    [ "${lines[2]}" = "TV_BASE=/tmp/tv" ]
}

@test "environment overrides default configuration" {
    export MEDIA_CONVERT_DIR=/tmp/convert
    export MEDIA_TRASH_DIR=/tmp/trash
    export MEDIA_TV_BASE=/tmp/tv

    run media show-config
    [ "${lines[0]}" = "CONVERT_DIR=/tmp/convert" ]
    [ "${lines[1]}" = "TRASH_DIR=/tmp/trash" ]
    [ "${lines[2]}" = "TV_BASE=/tmp/tv" ]
}

@test "environment overrides file overrides default configuration" {
    export MEDIA_CONFIG=tests/config/media.conf
    export MEDIA_CONVERT_DIR=/tmp/env/convert
    export MEDIA_TRASH_DIR=/tmp/env/trash
    export MEDIA_TV_BASE=/tmp/env/tv

    run media show-config
    [ "${lines[0]}" = "CONVERT_DIR=/tmp/env/convert" ]
    [ "${lines[1]}" = "TRASH_DIR=/tmp/env/trash" ]
    [ "${lines[2]}" = "TV_BASE=/tmp/env/tv" ]
}
