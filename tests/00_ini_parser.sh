#!/usr/bin/env bats

source bin/media

INI_FILE=tests/config/example.ini


@test "read a key" {
    local value

    value=$( config_key $INI_FILE hello )
    echo "** $value"
    [ "$value" == 'world' ]

    value=$( config_key $INI_FILE world )
    echo "** $value"
    [ "$value" == 'hello' ]
}

@test "read a key that appears twice, use only the latter value" {
    local value

    value=$( config_key $INI_FILE key )
    echo "** $value"
    [ "$value" == 'value' ]
}

@test "read a key from a section" {
    local value

    value=$( config_key $INI_FILE foo hello )
    echo "** $value"
    [ "$value" == 'bar' ]
}

@test "read a key from a section that also is in global, use only the section value" {
    local value

    value=$( config_key $INI_FILE hello hello )
    echo "** $value"
    [ "$value" == 'you' ]
}

@test "read a key from a section, ensuring a later section isn't used" {
    local value
    value=$( config_key $INI_FILE title 1 )
    echo "** $value"
    [ "$value" == 'track 1' ]
}

@test "read a key containing start of string anchor metacharacter" {
    local value
    value=$( config_key $INI_FILE '^bob' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing end of string anchor metacharacter" {
    value=$( config_key $INI_FILE 'bob$' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing brackets metacharacters" {
    value=$( config_key $INI_FILE '(bob)' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing a fullstop metacharacter" {
    value=$( config_key $INI_FILE 'b.b' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing a question mark metacharacter" {
    value=$( config_key $INI_FILE 'b?b' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing an asterisk metacharacter" {
    value=$( config_key $INI_FILE 'b*b' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing a plus metacharacter" {
    value=$( config_key $INI_FILE 'b+b' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read a key containing a vertical bar metacharacter" {
    value=$( config_key $INI_FILE 'b|b' )
    echo "** $value"
    [ "$value" == 'bob' ]
}

@test "read all keys from a section" {
    local -a expects=(
         '--album="Dignity"'
         '--artist="Deacon Blue"'
         '--compilation="false"'
         '--disk="1/1"'
         '--genre="Easy Listening"'
         '--purchaseDate="1970-01-01T12:00:00Z"'
         $'--title="Bethelehem\'s gate (Piano and vocal version)"'
         '--year="1994"'
    )

    config_as_atoms tests/config/metadata_cd.conf 04
    run config_as_atoms tests/config/metadata_cd.conf 04

    local count=0
    for line in "${expects[@]}"; do
        echo "count=$count ${expects[$count]} = ${lines[$count]}"
        [ "${expects[$count]}" = "${lines[$count]}" ]
        let count=count+1
    done
}
