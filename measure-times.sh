#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./common.sh

[[ $# = 1 ]] || fatal "usage: $0 RECIPE"

recipe=$1; shift

recipe_dir=$recipes_basedir/$recipe
work_dir=$work_basedir/$recipe

[[ -d "$recipe_dir" ]] || fatal "Recipe directory does not exist: $recipe_dir"

[[ -d "$work_dir" ]] || {
    ./clone.sh "$recipe_dir" "$work_dir"
    ./prepare.sh "$recipe_dir" "$work_dir"
}

time ./run-scan.sh "$recipe_dir" "$work_dir"
time ./wait-for-qg.sh "$work_dir"
