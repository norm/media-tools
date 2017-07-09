function count_atoms_in_file {
    local -r input="$1"

    AtomicParsley "$input" -t \
        | grep -v '^APar_readX read failed' \
        | wc -l \
        | tr -d ' '
}

function count_files_in_dir {
    find "$1" -type f \
        | wc -l \
        | tr -d ' '
}

function dir_is_empty {
    [ "$( count_files_in_dir "$1" )" = 0 ]
}

function needs_source {
    if [ ! -e "$1" ]; then
        skip "needs source $1"
    fi
}
