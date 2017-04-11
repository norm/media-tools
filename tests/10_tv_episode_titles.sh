#!/usr/bin/env bats


@test "lookup show id" {
    export MEDIA_TV_SHOWS=tests/config/tv_shows.conf
    source bin/media

    [ '5718' == $( lookup_tv_id 'The Flash' ) ]
    [ '35624' == $( lookup_tv_id 'The New Flash' ) ]
    [ -z $( lookup_tv_id 'No such show' ) ]
}


@test "gets episode titles with simple lookup" {
    source bin/media

    [ 'Top Secret' == "$( media-get-episode-title House 3 16 )" ]
    [ 'Strike' == "$( media-get-episode-title Superstore 2 1 )" ]
    [ 'Idle Hands' == "$( media-get-episode-title "Grey's Anatomy" 9 18 )" ]
}

@test "gets episode titles with ambiguous titles" {
    source bin/media

    [ 'City of Heroes' == "$( media-get-episode-title 'The Flash' 1 1 )" ]
    [ 'Pilot' == "$( media-get-episode-title 'The Flash 1990' 1 1 )" ]
}

@test "gets episode titles with weird titles" {
    source bin/media

    local title=$(
        media-get-episode-title "Marvel's Agents of S.H.I.E.L.D." 4 13
    )
    [ 'BOOM' == "$title" ]
}

@test "gets episode titles using lookups from shows file" {
    export MEDIA_TV_SHOWS=tests/config/tv_shows.conf
    source bin/media

    [ 'Pilot' == "$( media-get-episode-title 'The Flash' 1 1 )" ]
    [ 'City of Heroes' == "$( media-get-episode-title 'The New Flash' 1 1 )" ]
}
