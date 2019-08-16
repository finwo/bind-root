#!/usr/bin/env bash

# Ensure bash in approot
[ "$BASH" ] || exec bash $0 "$@"
cd "$(dirname "$0")/.."

# Ensure we have assert.sh for the linter
git submodule update --force --init --recursive

# We need eslint for the linter
npm install

# Can't have invalid code in npmjs
npm run linter

# Update contributors
cd scripts

# Reset values in package.json
./json.js --file ../package.json set contributors []

# Run through all contributors
{ git log --pretty="%ce %cn"; } | sort | uniq -c | while read line; do
  arr=($line)

  # Decompose
  commits=${arr[0]}
  email=${arr[1]}
  name="${arr[@]:2}"

  # Push contributor to package.json
  ./json.js --file ../package.json push contributors "$(cat <<EOF
{
  "name": "$name",
  "email": "$email",
  "contributions": $commits
}
EOF
)"
done

