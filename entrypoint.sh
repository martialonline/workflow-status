#!/bin/sh

set -euf

url="${GITHUB_API_URL}/repos"
repo="${GITHUB_REPOSITORY}"
run_id="${GITHUB_RUN_ID}"

failure=$(curl -s "${url}/${repo}/actions/runs/${run_id}/jobs" | \
jq -r '.jobs[] | select(.status == "completed" and .conclusion == "failure").conclusion' | \
wc -l)

cancelled=$(curl -s "${url}/${repo}/actions/runs/${run_id}/jobs" | \
jq -r '.jobs[] | select(.status == "completed" and .conclusion == "cancelled").conclusion' | \
wc -l)

if [ "${failure}" -gt 0 ]; then
  status="failure"
elif [ "${cancelled}" -gt 0 ]; then
  status="cancelled"
else 
  status="success"
fi

echo "::set-output name=status::${status}"
