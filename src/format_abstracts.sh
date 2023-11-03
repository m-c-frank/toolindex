#!/bin/bash
# Takes CSV input and prints each project title followed by the abstract.

while IFS=, read -r project abstract; do
    echo "PROJECT: $project"
    echo
    echo "ABSTRACT:"
    printf "%b\n" "$abstract"
    echo
    echo "________________________________________________________________________________"
done
