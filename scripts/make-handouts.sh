#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 slides/lectureNN_name.qmd"
  exit 1
fi

QMD="$1"
if [ ! -f "$QMD" ]; then
  echo "File not found: $QMD"
  exit 1
fi

base=$(basename "$QMD" .qmd)
HTML="docs/slides/${base}.html"
OUT_DIR="handouts"
pdf_tmp="$OUT_DIR/${base}.pdf"
pdf_out="$OUT_DIR/${base}_handout.pdf"

mkdir -p "$OUT_DIR"

echo "Rendering $base..."
quarto render "$QMD"

echo "Converting to PDF..."
decktape reveal --size 1600x900 \
  --chrome-path "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "$HTML" "$pdf_tmp"

echo "Arranging 2x2..."
pdfjam --nup 2x2 --landscape --paper letter --scale 0.95 "$pdf_tmp" --outfile "$pdf_out"
rm "$pdf_tmp"

echo "Done: $pdf_out"
