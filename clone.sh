#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./common.sh

[[ $# = 2 ]] || fatal "usage: $0 RECIPE_DIR WORK_DIR"

recipe_dir=$1; shift
work_dir=$1; shift

[[ -d "$recipe_dir" ]] || fatal "Recipe directory does not exist: $recipe_dir"
[[ ! -d "$work_dir" ]] || fatal "Work directory already exists: $work_dir"

repo_url=$(cat "$recipe_dir/url.txt")

git clone "$repo_url" "$work_dir"
