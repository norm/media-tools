#!/usr/bin/env bats

source bin/media

SINGLE_ID='39038f04'
SINGLE_QUERY='39038f04+4+150+19392+37012+52452+913'
SINGLE_TRACK_COUNT='4'

ALBUM_ID='a60b080d'
ALBUM_QUERY='a60b080d+13+150+7097+24365+38455+55750+76050+98650+113662+131645+147720+164357+188197+199987+2826'
ALBUM_TRACK_COUNT='13'


@test "calculate single CDDB ID" {
    local -a expects=(
        "media_disc_id=$SINGLE_ID"
        "media_disc_query=$SINGLE_QUERY"
        "media_disc_track_count=$SINGLE_TRACK_COUNT"
    )

    # override use of cdparanoia in media-get-cd-id
    export MEDIA_TESTING_CD_QUERY_FILE=tests/inputs/cdparanoia_single.txt
    media-get-cd-id
    run media-get-cd-id

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "calculate album CDDB ID" {
    local -a expects=(
        "media_disc_id=$ALBUM_ID"
        "media_disc_query=$ALBUM_QUERY"
        "media_disc_track_count=$ALBUM_TRACK_COUNT"
    )

    # override use of cdparanoia in media-get-cd-id
    export MEDIA_TESTING_CD_QUERY_FILE=tests/inputs/cdparanoia_album.txt
    media-get-cd-id
    run media-get-cd-id

    local count=0
    for line in "${expects[@]}"; do
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}

@test "get CDDB matches for single" {
    local expects="rock 39038f04 Deacon Blue / Dignity"
    local gets=$( cddb_matches "$SINGLE_QUERY" )

    cddb_matches "$SINGLE_QUERY"

    echo "expects='$expects'"
    echo "   gets='$gets'"
    [ "$gets" = "$expects" ]
}

@test "get CDDB matches for album" {
    local expects="misc a60b080d Deacon Blue / Raintown
rock a60b080d Depeche Mode / Violator"
    local gets=$( cddb_matches "$ALBUM_QUERY" )

    echo "expects='$expects'"
    echo "   gets='$gets'"
    [ "$gets" = "$expects" ]
}
