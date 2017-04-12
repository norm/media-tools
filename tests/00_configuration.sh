#!/usr/bin/env bats

@test "default configuration" {
    run media show-config
    [ "${lines[0]}" = "convert_dir   = /tmp" ]
    [ "${lines[1]}" = "ignore_itunes = " ]
    [ "${lines[2]}" = "trash_dir     = " ]
    [ "${lines[3]}" = "tv_base       = /files/tv" ]
}

@test "file overrides default configuration" {
    export MEDIA_CONFIG=tests/config/media.conf

    run media show-config
    [ "${lines[0]}" = "convert_dir   = /tmp/convert" ]
    [ "${lines[1]}" = "ignore_itunes = 1" ]
    [ "${lines[2]}" = "trash_dir     = /tmp/trash" ]
    [ "${lines[3]}" = "tv_base       = /tmp/tv" ]
}

@test "partial file doesn't override entire default configuration" {
    export MEDIA_CONFIG=tests/config/partial.conf

    run media show-config
    [ "${lines[0]}" = "convert_dir   = /tmp/convert" ]
    [ "${lines[1]}" = "ignore_itunes = " ]
    [ "${lines[2]}" = "trash_dir     = " ]
    [ "${lines[3]}" = "tv_base       = /files/tv" ]
}

@test "environment overrides default configuration" {
    export MEDIA_CONVERT_DIR=/tmp/convert
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TRASH_DIR=/tmp/trash
    export MEDIA_TV_BASE=/tmp/tv

    run media show-config
    [ "${lines[0]}" = "convert_dir   = /tmp/convert" ]
    [ "${lines[1]}" = "ignore_itunes = 1" ]
    [ "${lines[2]}" = "trash_dir     = /tmp/trash" ]
    [ "${lines[3]}" = "tv_base       = /tmp/tv" ]
}

@test "environment overrides file overrides default configuration" {
    export MEDIA_CONFIG=tests/config/media.conf
    export MEDIA_CONVERT_DIR=/tmp/env/convert
    export MEDIA_IGNORE_ITUNES=2
    export MEDIA_TRASH_DIR=/tmp/env/trash
    export MEDIA_TV_BASE=/tmp/env/tv

    run media show-config
    [ "${lines[0]}" = "convert_dir   = /tmp/env/convert" ]
    [ "${lines[1]}" = "ignore_itunes = 2" ]
    [ "${lines[2]}" = "trash_dir     = /tmp/env/trash" ]
    [ "${lines[3]}" = "tv_base       = /tmp/env/tv" ]
}
