#!/usr/bin/env bats

@test "extracts TV with simple metadata" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "House - 1x01 - Pilot" ) )
    [ "${metadata[0]}" == '--TVShowName=House' ]
    [ "${metadata[1]}" == '--TVSeasonNum=1' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=01' ]
    [ "${metadata[3]}" == '--title=Pilot' ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "extracts TV with more complex metadata" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "Star Trek - Voyager - 5x101 - Extras - Crew Dossier - Qwark" ) )
    [ "${metadata[0]}" == '--TVShowName=Star Trek - Voyager' ]
    [ "${metadata[1]}" == '--TVSeasonNum=5' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=101' ]
    [ "${metadata[3]}" == '--title=Extras - Crew Dossier - Qwark' ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "extracts TV with shell metacharacters" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "Grey's Anatomy - 2x11 - Owner of a Lonely Heart" ) )
    [ "${metadata[0]}" == "--TVShowName=Grey's Anatomy" ]
    [ "${metadata[1]}" == '--TVSeasonNum=2' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=11' ]
    [ "${metadata[3]}" == '--title=Owner of a Lonely Heart' ]
    [ "${metadata[4]}" == '--stik=TV Show' ]

    eval metadata=( $( media-extract-metadata "American Dad! - 5x12 - May the Best Stan Win" ) )
    [ "${metadata[0]}" == '--TVShowName=American Dad!' ]
    [ "${metadata[1]}" == '--TVSeasonNum=5' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=12' ]
    [ "${metadata[3]}" == '--title=May the Best Stan Win' ]
    [ "${metadata[4]}" == '--stik=TV Show' ]

    eval metadata=( $( media-extract-metadata "House - 2x23 - Who's Your Daddy?" ) )
    [ "${metadata[0]}" == '--TVShowName=House' ]
    [ "${metadata[1]}" == '--TVSeasonNum=2' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=23' ]
    [ "${metadata[3]}" == "--title=Who's Your Daddy?" ]
    [ "${metadata[4]}" == '--stik=TV Show' ]

    eval metadata=( $( media-extract-metadata "Timeless - 1x09 - Last Ride of Bonnie & Clyde" ) )
    [ "${metadata[0]}" == '--TVShowName=Timeless' ]
    [ "${metadata[1]}" == '--TVSeasonNum=1' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=09' ]
    [ "${metadata[3]}" == "--title=Last Ride of Bonnie & Clyde" ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "extracts TV ignoring path" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "stuff/to/process/House - 1x01 - Pilot/" ) )
    [ "${metadata[0]}" == '--TVShowName=House' ]
    [ "${metadata[1]}" == '--TVSeasonNum=1' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=01' ]
    [ "${metadata[3]}" == '--title=Pilot' ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "extracts when perl array symbols exist" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "Show - 1x01 - @Email" ) )
    [ "${metadata[3]}" == '--title=@Email' ]
}

@test "extracts when perl hash symbols exist" {
    local -a metadata
    eval metadata=( $( media-extract-metadata "Show - 1x01 - %Percent" ) )
    [ "${metadata[3]}" == '--title=%Percent' ]
}

@test "extracts when perl scalar symbols exist" {
    local -a metadata
    eval metadata=( $( media-extract-metadata 'Show - 1x01 - $Money' ) )
    echo META="${metadata[@]}"
    echo META="${metadata[3]}"
    [ "${metadata[3]}" == '--title=$Money' ]
}

@test "extracts using a config file if present" {
    eval metadata=( $( media-extract-metadata tests/config ) )
    [ "${metadata[0]}" == '--TVShowName=House' ]
    [ "${metadata[1]}" == '--TVSeasonNum=2' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=23' ]
    [ "${metadata[3]}" == "--title=Who's Your Daddy?" ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "extracts using the config file in precedence to the dir name" {
    local -r source_dir="$( mktemp -d )"
    local -r source="$source_dir/House - 1x01 - Pilot"

    mkdir "$source"
    cp tests/config/metadata.conf "$source/metadata.conf"

    eval metadata=( $( media-extract-metadata "$source" ) )
    [ "${metadata[0]}" == '--TVShowName=House' ]
    [ "${metadata[1]}" == '--TVSeasonNum=2' ]
    [ "${metadata[2]}" == '--TVEpisodeNum=23' ]
    [ "${metadata[3]}" == "--title=Who's Your Daddy?" ]
    [ "${metadata[4]}" == '--stik=TV Show' ]
}

@test "otherwise does nothing" {
    metadata="$( media-extract-metadata "what am I?" )"
    echo "$metadata"
    [ "$metadata" == "Error: unknown format 'what am I?'" ]
}
