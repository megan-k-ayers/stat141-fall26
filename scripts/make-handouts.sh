#!/usr/bin/env bash
set -euo pipefail

SLIDES_DIR="docs/slides"
OUT_DIR="handouts"
mkdir -p "$OUT_DIR"

for html in "$SLIDES_DIR"/lecture*.html; do
  [ -f "$html" ] || continue
  base=$(basename "$html" .html)
  pdf_tmp="$OUT_DIR/${base}.pdf"
  pdf_out="$OUT_DIR/${base}_handout.pdf"

  echo "  $base..."
  decktape reveal --size 1600x900 "$html" "$pdf_tmp"
  pdfjam --nup 2x2 --landscape "$pdf_tmp" --outfile "$pdf_out"
  rm "$pdf_tmp"
done

echo "Done. Handouts in $OUT_DIR/"
