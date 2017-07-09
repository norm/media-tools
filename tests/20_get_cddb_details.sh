#!/usr/bin/env bats

export MEDIA_CD_RIP_DIR=$( mktemp )
source bin/media-create-audio-metadata


@test "get CD single CDDB details" {
    create_cd_metadata "rock 39038f04"
    diff -u \
        tests/inputs/single_metadata.conf \
        "$MEDIA_CD_RIP_DIR/39038f04/metadata.conf"
}

@test "get CD album CDDB details" {
    create_cd_metadata "misc a60b080d"
    diff -u \
        tests/inputs/album_metadata.conf \
        "$MEDIA_CD_RIP_DIR/a60b080d/metadata.conf"
}

rm -rf "$MEDIA_CD_RIP_DIR"
