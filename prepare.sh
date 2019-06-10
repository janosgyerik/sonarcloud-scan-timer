#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./common.sh

[[ $# = 2 ]] || fatal "usage: $0 RECIPE_DIR WORK_DIR"

recipe_dir=$1; shift
work_dir=$1; shift

prepare_sh=$recipe_dir/prepare.sh

[[ -f "$prepare_sh" ]] || fatal "Prepare script does not exist: $prepare_sh"
[[ -d "$work_dir" ]] || fatal "Work directory does not exist: $work_dir"

cp -v "$prepare_sh" "$work_dir"

(cd "$work_dir" && bash ./prepare.sh)
