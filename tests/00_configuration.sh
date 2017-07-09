#!/usr/bin/env bats

@test "default configuration" {
    local -a expects=(
        "convert_dir   = /tmp"
        "ignore_itunes = "
        "trash_dir     = "
        "tv_base       = /files/tv"
    )

    media show-config
    run media show-config

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "file overrides default configuration" {
    local -a expects=(
        "convert_dir   = /tmp/convert"
        "ignore_itunes = 1"
        "trash_dir     = /tmp/trash"
        "tv_base       = /tmp/tv"
    )

    export MEDIA_CONFIG=tests/config/media.conf
    media show-config
    run media show-config

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "partial file doesn't override entire default configuration" {
    local -a expects=(
        "convert_dir   = /tmp/convert"
        "ignore_itunes = "
        "trash_dir     = "
        "tv_base       = /files/tv"
    )

    export MEDIA_CONFIG=tests/config/partial.conf
    media show-config
    run media show-config

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "environment overrides default configuration" {
    local -a expects=(
        "convert_dir   = /tmp/convert"
        "ignore_itunes = 1"
        "trash_dir     = /tmp/trash"
        "tv_base       = /tmp/tv"
    )

    export MEDIA_CONVERT_DIR=/tmp/convert
    export MEDIA_IGNORE_ITUNES=1
    export MEDIA_TRASH_DIR=/tmp/trash
    export MEDIA_TV_BASE=/tmp/tv
    media show-config
    run media show-config

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "environment overrides file overrides default configuration" {
    local -a expects=(
        "convert_dir   = /tmp/env/convert"
        "ignore_itunes = 2"
        "trash_dir     = /tmp/env/trash"
        "tv_base       = /tmp/env/tv"
    )

    export MEDIA_CONFIG=tests/config/media.conf
    export MEDIA_CONVERT_DIR=/tmp/env/convert
    export MEDIA_IGNORE_ITUNES=2
    export MEDIA_TRASH_DIR=/tmp/env/trash
    export MEDIA_TV_BASE=/tmp/env/tv
    media show-config
    run media show-config

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}
