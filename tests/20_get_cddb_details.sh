#!/usr/bin/env bats

export MEDIA_CD_RIP_DIR=$( mktemp -d )
source bin/media-create-audio-metadata


@test "get CD single CDDB details" {
    media_disc_id=39038f04
    media_disc_track_count=4
    media_disc_first_audio_track=1
    create_cd_metadata "rock 39038f04"
    diff -u \
        tests/inputs/single_metadata.conf \
        "$MEDIA_CD_RIP_DIR/39038f04/metadata.conf"
}

@test "get CD album CDDB details" {
    media_disc_id=a60b080d
    media_disc_track_count=13
    media_disc_first_audio_track=1
    create_cd_metadata "misc a60b080d"
    diff -u \
        tests/inputs/album_metadata.conf \
        "$MEDIA_CD_RIP_DIR/a60b080d/metadata.conf"
}

@test "get CD mixed media CDDB details" {
    media_disc_id=f80d9039
    media_disc_track_count=57
    media_disc_first_audio_track=2
    create_cd_metadata "misc f80d9039"
    diff -u \
        tests/inputs/mixed_media_metadata.conf \
        "$MEDIA_CD_RIP_DIR/f80d9039/metadata.conf"
}

rm -rf "$MEDIA_CD_RIP_DIR"
