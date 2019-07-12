#!/usr/bin/env bash

# Ensure bash in approot
[ "$BASH" ] || exec bash $0 "$@"
cd "$(dirname "$0")/.."

# Load assert lib
source 'lib/assert/assert.sh'
error=0

# Install deps if needed
[ -f "node_modules/.bin/eslint" ] || {
  npm install
}

# Find and lint all javascript files
while IFS= read filename; do
  node_modules/.bin/eslint --cache "${filename}" "$@"
  if [ "$?" == 0 ]; then
    log_success "${filename}"
  else
    log_failure "${filename}"
    error=1
  fi
done < <( find -name '*.js' | \
  sort | \
  grep -v node_modules | \
  egrep -v "^\.\/api\/_site" | \
  egrep -v "^\.\/frontend\/docroot\/assets\/" | \
  egrep -v "^\.\/lib\/js\-interpreter\/" | \
  egrep -v '\/\.eslintrc\.js$'
)

# Find and lint all json files
while IFS= read filename; do
  node_modules/.bin/eslint --cache "${filename}" "$@"
  if [ "$?" == 0 ]; then
    log_success "${filename}"
  else
    log_failure "${filename}"
    error=1
  fi
done < <( find -name '*.json' | \
  sort | \
  grep -v node_modules | \
  egrep -v "^\.\/frontend\/docroot\/assets\/" | \
  egrep -v '\/\.eslintrc\.json$' | \
  egrep -v '\/\.nyc_output\/' | \
  egrep -v '\/bower\.json$'
)

exit $error
