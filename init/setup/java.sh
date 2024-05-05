# #!/bin/bash

# Install Corretto Java8
# https://docs.aws.amazon.com/ja_jp/corretto/latest/corretto-8-ug/downloads-list.html

URL="https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
TEMP_FILE="/tmp/amazon-corretto-8-aarch64-macos-jdk.tar.gz"
TARGET_DIR="$HOME/java"

[ -f "$TEMP_FILE" ] && rm "$TEMP_FILE"

wget -O "$TEMP_FILE" $URL
[ -d "$TARGET_DIR" ] || mkdir -p "$TARGET_DIR"
tar -xzvf "$TEMP_FILE" -C "$TARGET_DIR"

rm "$TEMP_FILE"
