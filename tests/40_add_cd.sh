#!/usr/bin/env bats

source bin/media
source tests/lib.sh


@test "add a CD" {
    needs_source tests/source/39038f04

    export MEDIA_CD_RIP_DIR=$( mktemp -d )
    export MEDIA_AUTO_ADD_DIR=$( mktemp -d )
    echo "** rip_dir=$MEDIA_CD_RIP_DIR"
    echo "** add_dir=$MEDIA_AUTO_ADD_DIR"

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
    [ "$( media_lookup_atom "$track" aART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" ©ART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" stik )" = 'Normal' ]
    [ $( count_atoms_in_file "$track" ) = 12 ]

    track="$MEDIA_AUTO_ADD_DIR/02.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '2 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = 'Beautiful Stranger' ]
    [ "$( media_lookup_atom "$track" aART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" ©ART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" stik )" = 'Normal' ]
    [ $( count_atoms_in_file "$track" ) = 12 ]

    track="$MEDIA_AUTO_ADD_DIR/03.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '3 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = 'Waves of sorrow (Piano and vocal version)' ]
    [ "$( media_lookup_atom "$track" aART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" ©ART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" stik )" = 'Normal' ]
    [ $( count_atoms_in_file "$track" ) = 12 ]

    track="$MEDIA_AUTO_ADD_DIR/04.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '4 of 4' ]
    [ "$( media_lookup_atom "$track" ©nam )" = "Bethelehem's gate (Piano and vocal version)" ]
    [ "$( media_lookup_atom "$track" aART )" = 'Deacon Blue' ]
    [ "$( media_lookup_atom "$track" ©ART )" = 'Deacon Bloo' ]
    [ "$( media_lookup_atom "$track" ©cmt )" = 'Really by Deacon Blue' ]
    [ "$( media_lookup_atom "$track" stik )" = 'Normal' ]
    [ $( count_atoms_in_file "$track" ) = 13 ]

    rm -rf "$MEDIA_CD_RIP_DIR" "$MEDIA_AUTO_ADD_DIR"
}

@test "add a mixed-media CD" {
    needs_source tests/source/tomb_raider

    export MEDIA_CD_RIP_DIR=$( mktemp -d )
    export MEDIA_AUTO_ADD_DIR=$( mktemp -d )
    echo "** rip_dir=$MEDIA_CD_RIP_DIR"
    echo "** add_dir=$MEDIA_AUTO_ADD_DIR"

    rsync -a --delete tests/source/tomb_raider "$MEDIA_CD_RIP_DIR"

    find "$MEDIA_CD_RIP_DIR" -type f

    # should have copied seven files (5 wav, 1 metadata.conf, 1 cover.jpg)
    [ $( count_files_in_dir "$MEDIA_CD_RIP_DIR" ) = 7 ]

    # should not be any files in auto-add dir
    dir_is_empty "$MEDIA_AUTO_ADD_DIR"

    media-add-cd tomb_raider

    # should now have five output files
    [ $( count_files_in_dir "$MEDIA_AUTO_ADD_DIR" ) = 5 ]

    local track
    track="$MEDIA_AUTO_ADD_DIR/01.m4a"
    [ -f "$track" ]
    [ "$( media_lookup_atom "$track" trkn )" = '1 of 5' ]
    [ "$( media_lookup_atom "$track" ©nam )" = '"Here lies Tahocan…"' ]
    [ "$( media_lookup_atom "$track" aART )" = 'Nathan McCree' ]
    [ "$( media_lookup_atom "$track" ©ART )" = 'Nathan McCree' ]
    [ "$( media_lookup_atom "$track" stik )" = 'Normal' ]
    [ "$( media_lookup_atom "$track" gnre )" = 'Game' ]
    [ "$( media_lookup_atom "$track" purd )" = '1996-10-25T12:00:00Z' ]
    [ "$( media_lookup_atom "$track" ©day )" = '1996-10-25T12:00:00Z' ]
    [ $( count_atoms_in_file "$track" ) = 13 ]

    rm -rf "$MEDIA_CD_RIP_DIR" "$MEDIA_AUTO_ADD_DIR"
}
