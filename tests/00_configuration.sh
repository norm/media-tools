#!/usr/bin/env bats

@test "default configuration" {
    local -a expects=(
        "auto_add_dir  = "
        "cache_dir     = ${HOME}/Library/Caches/media-tools"
        "cd_rip_dir    = ${HOME}/Music/rips"
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
        "auto_add_dir  = /tmp/add"
        "cache_dir     = /tmp/cache"
        "cd_rip_dir    = /tmp/rips"
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
        "auto_add_dir  = "
        "cache_dir     = ${HOME}/Library/Caches/media-tools"
        "cd_rip_dir    = ${HOME}/Music/rips"
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
        "auto_add_dir  = "
        "cache_dir     = ${HOME}/Library/Caches/media-tools"
        "cd_rip_dir    = ${HOME}/Music/rips"
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
        "auto_add_dir  = /tmp/env/add"
        "cache_dir     = /tmp/env/cache"
        "cd_rip_dir    = /tmp/env/rip"
        "convert_dir   = /tmp/env/convert"
        "ignore_itunes = 2"
        "trash_dir     = /tmp/env/trash"
        "tv_base       = /tmp/env/tv"
    )

    export MEDIA_CONFIG=tests/config/media.conf
    export MEDIA_AUTO_ADD_DIR=/tmp/env/add
    export MEDIA_CACHE_DIR=/tmp/env/cache
    export MEDIA_CD_RIP_DIR=/tmp/env/rip
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
