#!/usr/bin/env bats

source bin/media
source tests/lib.sh


function setup {
    export MEDIA_CD_RIP_DIR=$( mktemp -d )
    export MEDIA_AUTO_ADD_DIR=$( mktemp -d )
}

function teardown {
    rm -rf "$MEDIA_CD_RIP_DIR" "$MEDIA_AUTO_ADD_DIR"
}


@test "add a CD" {
    needs_source tests/source/39038f04

    rsync -a --delete tests/source/39038f04 "$MEDIA_CD_RIP_DIR"

    # should have copied five files (4 wav, 1 metadata.conf)
    [ $( count_files_in_dir "$MEDIA_CD_RIP_DIR" ) = 5 ]

    # should not be any files in auto-add dir
    dir_is_empty "$MEDIA_AUTO_ADD_DIR"

    media-add-cd 39038f04

    # should now have four output files
    [ $( count_files_in_dir "$MEDIA_AUTO_ADD_DIR" ) = 4 ]

    local track
    track="$MEDIA_AUTO_ADD_DIR/01.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '1 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = 'Dignity' ]

    track="$MEDIA_AUTO_ADD_DIR/02.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '2 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = 'Beautiful Stranger' ]

    track="$MEDIA_AUTO_ADD_DIR/03.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '3 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = 'Waves of sorrow (Piano and vocal version)' ]

    track="$MEDIA_AUTO_ADD_DIR/04.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '4 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = "Bethelehem's gate (Piano and vocal version)" ]
}
