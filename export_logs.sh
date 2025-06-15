#!/bin/bash

# 入力ディレクトリ（第一引数）と出力ファイル名（第二引数）
INPUT_DIR="${1:-.}"
OUTPUT_FILE="${2:-$HOME/Downloads/combined.txt}"

# 出力ファイルを初期化
> "$OUTPUT_FILE"

# .md ファイルを再帰的に検索し、アルファベット順で処理
find "$INPUT_DIR" -type f -name "*.md" | sort | while read -r file; do
  echo "==== ${file} ====" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done

echo "✅ 変換完了: $OUTPUT_FILE"

