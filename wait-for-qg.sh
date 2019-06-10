#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

. ./common.sh

[[ $# = 1 ]] || fatal "usage: $0 WORK_DIR"

work_dir=$1; shift

report_path=$work_dir/$report_filename
[[ -f "$report_path" ]] || fatal "Report file does not exist: $report_path"

[[ -f "$sonarcloud_token_path" ]] || fatal "SonarCloud token file does not exist: $sonarcloud_token_path"

sonarcloud_token=$(cat "$sonarcloud_token_path")

is_task_url_in_report() {
    grep -q 'More about the report processing' "$report_path"
}

is_gradle_build() {
    [[ -f "$work_dir/build/sonar/report-task.txt" ]]
}

if is_task_url_in_report; then
    ceTaskUrl=$(sed -n 's/INFO: More about the report processing at \(.*\)/\1/p' "$report_path")
    msg "task url found in scanner output: $ceTaskUrl"
elif is_gradle_build; then
    . "$work_dir/build/sonar/report-task.txt"
    msg "task url found in gradle report: $ceTaskUrl"
fi

while true; do
    task=$(curl --silent --user "$sonarcloud_token:" "$ceTaskUrl")
    status=$(jq -r '.task.status' <<< "$task")
    if [[ ${status} != "PENDING" && ${status} != "IN_PROGRESS" ]]; then
        break
    fi
    printf '.'
    sleep 1
done
