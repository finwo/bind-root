#!/usr/bin/env bash

# Ensure bash in script dir
[ "$BASH" ] || exec bash $0 "$@"
cd "$(dirname "$0")"

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

