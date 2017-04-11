#!/usr/bin/env bats

@test "HandBrakeCLI is installed" {
    which HandBrakeCLI
}

@test "HandBrakeCLI is the right version" {
    local version=$(
        HandBrakeCLI --version 2>&1 \
            | grep ^HandBrake \
            | cut -c11-
    )
    [ "$version" == '1.0.7' ]
}

@test "AtomicParsley is installed" {
    which AtomicParsley
}

@test "AtomicParsley is the right version" {
    run AtomicParsley --version
    [ "$output" == "AtomicParsley version: 0.9.6 (utf8)" ]
}
