#!/bin/bash

# エラー発生時にスクリプトを停止
set -e

# 作業ディレクトリをスクリプトの場所に設定
cd "data"

echo "Starting data fetch process..."

# 年度と学期のループ
for YEAR in {2022..2024}; do
  for SEMESTER in 0 1; do
    echo "Fetching data for year $YEAR, semester $SEMESTER"

    if [ -s "$YEAR/$SEMESTER/data.json" ]; then
      echo "Data already fetched for year $YEAR, semester $SEMESTER. Skipping..."
      continue
    fi

    OUTPUT_DIR="${YEAR}/${SEMESTER}"
    mkdir -p "$OUTPUT_DIR"

    echo "Fetching course data from API..."
    response=$(curl -k -s -S --retry 3 --max-time 30 "https://catalog.sp.omu.ac.jp/api/search.json?year=$YEAR&semesters=$SEMESTER" 2>&1)

    if [[ $? -ne 0 ]]; then
      echo "Error fetching data from API: $response"
      exit 1
    fi

    echo "Processing data..."
    # 例: jqを使用してJSONデータを処理
    if command -v jq &> /dev/null; then
      echo "$response" | jq '.data' > "$YEAR/$SEMESTER/data.json"
    else
        echo "jq command not found. Please install jq to process JSON data."
        exit 1
    fi

    echo "Completed fetch for year $YEAR, semester $SEMESTER"
  done
done

echo "All data fetching completed successfully."
chmod +x .././fetch.sh
