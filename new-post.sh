#!/usr/bin/env bash
#
# Scaffold a new blog post under posts/.
#
# Usage:
#   ./new-post.sh "My Post Title"
#   ./new-post.sh "My Post Title" "Author Name"
#   ./new-post.sh "My Post Title" "Author Name" my-custom-slug
#
# Creates posts/<slug>/index.qmd with front matter filled in (today's date),
# then prints the path. New posts show up on the blogroll automatically.

set -euo pipefail

# Run from the repo root (directory this script lives in), so it works
# regardless of where it's invoked from.
cd "$(dirname "$0")"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 \"Post Title\" [\"Author Name\"] [custom-slug]" >&2
  exit 1
fi

title="$1"
author="${2:-Your Name}"

# Slug: explicit third arg, else derive from the title.
if [[ $# -ge 3 && -n "$3" ]]; then
  slug="$3"
else
  slug="$(printf '%s' "$title" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
fi

if [[ -z "$slug" ]]; then
  echo "Error: could not derive a slug from the title; pass one explicitly." >&2
  exit 1
fi

date="$(date +%Y-%m-%d)"
dir="posts/$slug"
file="$dir/index.qmd"

if [[ -e "$file" ]]; then
  echo "Error: $file already exists — pick a different slug." >&2
  exit 1
fi

mkdir -p "$dir"
cat > "$file" <<EOF
---
title: "$title"
author: "$author"
date: "$date"
description: "A one-line description shown under the title on the blogroll."
---

Write your post here.
EOF

echo "Created $file"
