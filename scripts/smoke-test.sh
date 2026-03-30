#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

(cd "$tmpdir" && quarto add "$repo_root" --no-prompt --quiet --log-level error)

cp "$repo_root"/example.qmd "$tmpdir"/
cp "$repo_root"/template.qmd "$tmpdir"/
cp "$repo_root"/no-r-smoke.qmd "$tmpdir"/

cd "$tmpdir"

quarto render example.qmd
quarto render template.qmd
quarto render no-r-smoke.qmd
