#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./common.sh

[[ $# = 2 ]] || fatal "usage: $0 RECIPE_DIR WORK_DIR"

recipe_dir=$1; shift
work_dir=$1; shift

run_scan_sh=$recipe_dir/run-scan.sh

[[ -f "$run_scan_sh" ]] || fatal "Run scan script does not exist: $run_scan_sh"
[[ -d "$work_dir" ]] || fatal "Work directory does not exist: $work_dir"

cp -v "$run_scan_sh" "$work_dir"

(cd "$work_dir" && bash ./run-scan.sh 2>/dev/null | tee "$report_filename")
