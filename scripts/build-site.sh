#!/usr/bin/env bash
# Builds public/ from every talks/<name>/slides.md: a static HTML view
# (gophern html) and a downloadable PDF (gophern export) per talk, plus a
# root index.html that embeds the most recently changed talk (by git log)
# front and center, with every talk (including that one) listed below with
# view/download links. Requires `gophern` on PATH and full git history
# (fetch-depth: 0) so `git log` can date each talks/<name>/ directory.
set -euo pipefail

if ! command -v gophern >/dev/null 2>&1; then
  echo "Error: gophern not found on PATH. Install it first (go install github.com/gophernment/gophern@latest) and make sure \$(go env GOPATH)/bin is on PATH." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

rm -rf public
mkdir -p public

names=()
titles=()
timestamps=()

for dir in talks/*/; do
  name="$(basename "$dir")"
  slides="${dir}slides.md"
  if [ ! -f "$slides" ]; then
    continue
  fi

  outdir="public/talks/$name"
  mkdir -p "$outdir"

  echo "Building talk: $name"
  gophern html -o "$outdir/index.html" "$slides"
  gophern export -o "$outdir/presentation.pdf" "$slides"

  if [ -d "${dir}asset" ]; then
    cp -r "${dir}asset" "$outdir/asset"
  fi

  title="$(grep -m1 '^title:' "$slides" | sed -E 's/^title:[[:space:]]*"?([^"]*)"?[[:space:]]*$/\1/')"
  if [ -z "$title" ]; then
    title="$name"
  fi

  # Recency = last commit that touched this talk's directory. Falls back to
  # "now" for an uncommitted talk (e.g. testing locally before a first commit).
  ts="$(git log -1 --format=%ct -- "$dir" 2>/dev/null || true)"
  if [ -z "$ts" ]; then
    ts="$(date +%s)"
  fi

  names+=("$name")
  titles+=("$title")
  timestamps+=("$ts")
done

if [ "${#names[@]}" -eq 0 ]; then
  echo "No talks found under talks/*/slides.md" >&2
  exit 1
fi

# Find the index of the most recent talk.
latest_idx=0
for i in "${!timestamps[@]}"; do
  if [ "${timestamps[$i]}" -gt "${timestamps[$latest_idx]}" ]; then
    latest_idx=$i
  fi
done
latest_name="${names[$latest_idx]}"
latest_title="${titles[$latest_idx]}"

# Build the "all talks" list, newest first.
order=($(for i in "${!timestamps[@]}"; do echo "${timestamps[$i]} $i"; done | sort -rn | awk '{print $2}'))

list_items=""
for i in "${order[@]}"; do
  n="${names[$i]}"
  t="${titles[$i]}"
  suffix=""
  if [ "$n" = "$latest_name" ]; then
    suffix=" (latest)"
  fi
  list_items="${list_items}    <li><a href=\"talks/${n}/\">${t}</a>${suffix} — <a href=\"talks/${n}/presentation.pdf\">PDF</a></li>\n"
done

cat > public/index.html <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${latest_title}</title>
<style>
  body { font-family: system-ui, sans-serif; max-width: 60rem; margin: 2rem auto; padding: 0 1rem; }
  iframe { width: 100%; height: 75vh; border: 1px solid #ccc; border-radius: 8px; }
  h2 { font-size: 1rem; color: #555; margin-top: 2.5rem; }
  li { margin-bottom: 0.5rem; }
  a { color: #2563eb; }
</style>
</head>
<body>
<iframe src="talks/${latest_name}/" title="${latest_title}"></iframe>
<p><a href="talks/${latest_name}/presentation.pdf">Download this talk as PDF</a></p>

<h2>All talks</h2>
<ul>
$(echo -e "$list_items")
</ul>
</body>
</html>
HTML

echo "Done. Output in public/ (latest talk: $latest_name)"
