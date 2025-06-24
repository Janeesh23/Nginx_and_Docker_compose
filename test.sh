#!/bin/bash

set -e

echo "Running API route checks via Nginx reverse proxy on http://localhost:8080"
echo "------------------------------------------------------------"

declare -A routes=(
  ["Service 1 /ping"]="/service1/ping"
  ["Service 1 /hello"]="/service1/hello"
  ["Service 2 /ping"]="/service2/ping"
  ["Service 2 /hello"]="/service2/hello"
)

failed=false

for label in "${!routes[@]}"; do
  url="http://localhost:8080${routes[$label]}"
  echo -n "Testing $label at $url ... "

  status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [ "$status_code" == "200" ]; then
    echo "OK (200)"
  else
    echo "Failed (HTTP $status_code)"
    failed=true
  fi
done

echo "------------------------------------------------------------"
echo "Last 4 custom log entries from Nginx (timestamp | IP | path | status):"
docker-compose logs --no-log-prefix --tail=100 nginx 2>/dev/null | grep '|' | grep "/service" | tail -n 4

echo "------------------------------------------------------------"
if [ "$failed" = true ]; then
  echo "One or more routes are failing. Please investigate."
  exit 1
else
  echo "All routes are healthy and reverse proxy is working."
  exit 0
fi
