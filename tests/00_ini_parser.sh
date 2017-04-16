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
