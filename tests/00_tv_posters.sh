#!/usr/bin/env bats


SERIES='Buffy the Vampire Slayer'
SEASON='4'


@test "finds a generic series poster" {
    export MEDIA_TV_BASE=$( mktemp -d )
    source bin/media

    mkdir -p "$MEDIA_TV_BASE/posters"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/posters/$SERIES.jpg"

    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/posters/$SERIES.jpg" ]

    # prefers PNG to JPEG
    cp tests/source/poster.png "$MEDIA_TV_BASE/posters/$SERIES.png"
    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/posters/$SERIES.png" ]

    rm -rf "$MEDIA_TV_BASE"
}

@test "finds a series poster in the series dir" {
    export MEDIA_TV_BASE=$( mktemp -d )
    source bin/media

    mkdir -p "$MEDIA_TV_BASE/posters"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/posters/$SERIES.jpg"
    mkdir -p "$MEDIA_TV_BASE/$SERIES"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/$SERIES/poster.jpg"

    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/$SERIES/poster.jpg" ]

    # prefers PNG to JPEG
    cp tests/source/poster.png "$MEDIA_TV_BASE/posters/$SERIES.png"
    cp tests/source/poster.png "$MEDIA_TV_BASE/$SERIES/poster.png"

    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/$SERIES/poster.png" ]

    rm -rf "$MEDIA_TV_BASE"
}

@test "finds a series season specific poster" {
    export MEDIA_TV_BASE=$( mktemp -d )
    source bin/media

    mkdir -p "$MEDIA_TV_BASE/posters"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/posters/$SERIES.jpg"
    mkdir -p "$MEDIA_TV_BASE/$SERIES/Season $SEASON"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/$SERIES/poster.jpg"
    cp tests/source/tv.jpg "$MEDIA_TV_BASE/$SERIES/Season $SEASON/poster.jpg"

    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/$SERIES/Season $SEASON/poster.jpg" ]

    # prefers PNG to JPEG
    cp tests/source/poster.png "$MEDIA_TV_BASE/posters/$SERIES.png"
    cp tests/source/poster.png "$MEDIA_TV_BASE/$SERIES/poster.png"
    cp tests/source/poster.png "$MEDIA_TV_BASE/$SERIES/Season $SEASON/poster.png"

    get_tv_series_poster "$SERIES" "$SEASON"
    run get_tv_series_poster "$SERIES" "$SEASON"
    [ "$output" = "$MEDIA_TV_BASE/$SERIES/Season $SEASON/poster.png" ]

    rm -rf "$MEDIA_TV_BASE"
}