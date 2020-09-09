#!/bin/sh

set -euf

url="${GITHUB_API_URL}/repos"
repo="${GITHUB_REPOSITORY}"
run_id="${GITHUB_RUN_ID}"

failures=$(curl -s "${url}/${repo}/actions/runs/${run_id}/jobs" | \
jq -r '.jobs[].steps[]| select(.status == "completed" and .conclusion=="failure").conclusion' | \
wc -l)

if [ "${failures}" -gt 0 ]; then
  status="failed"
else 
  status="success"
fi

echo "::set-output name=status::${status}"
