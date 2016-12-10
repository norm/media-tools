#!/usr/bin/env bats

@test "HandBrakeCLI is installed" {
    which HandBrakeCLI
}

@test "HandBrakeCLI is the right version" {
    local version=$(
        HandBrakeCLI -i /dev/null -t0 2>&1  \
            | grep ^HandBrake               \
            | grep -v exited                \
            | cut -c11-16
    )
    [ "$version" == '0.10.5' ]
}

@test "AtomicParsley is installed" {
    which AtomicParsley
}

@test "AtomicParsley is the right version" {
    run AtomicParsley --version
    [ "$output" == "AtomicParsley version: 0.9.6 (utf8)" ]
}
