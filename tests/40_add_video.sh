#!/usr/bin/env bats

source bin/media


@test "adds a TV show" {
    export MEDIA_TV_BASE=$( mktemp -d )

    # there should be nothing before we begin
    count=$( find $MEDIA_TV_BASE -type f | wc -l | tr -d ' ' )
    [ "$count" = 0 ]

    media-add "tests/process/House - 1x01 - Pilot"

    # media-add should have installed converted TV
    count=$( find $MEDIA_TV_BASE -type f | wc -l | tr -d ' ' )
    local installed="$MEDIA_TV_BASE/House/Season 1/01 Pilot.m4v"

    [ -f "$installed" ]
    [ "$count" = 1 ]
    [ "$( media_lookup_atom "$installed" tvsh )" = 'House' ]
    [ "$( media_lookup_atom "$installed" tvsn )" = '1' ]
    [ "$( media_lookup_atom "$installed" tves )" = '1' ]
    [ "$( media_lookup_atom "$installed" tven )" = '1x01' ]
    [ "$( media_lookup_atom "$installed" ©nam )" = 'Pilot' ]
    [ "$( media_lookup_atom "$installed" stik )" = 'TV Show' ]
    [ "$( media_lookup_atom "$installed" covr )" = '1 piece of artwork' ]

    rm -rf $MEDIA_TV_BASE
}
