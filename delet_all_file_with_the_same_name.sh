#!/bin/bash

# 检查是否传入文件名
if [ -z "$1" ]; then
    echo "用法: $0 filename"
    exit 1
fi

TARGET="$1"

echo "正在搜索并删除所有子目录中的 '$TARGET' 文件..."
find . -type f -name "$TARGET" -print -delete
echo "完成!"

#find . -type f -name "TARGET_FILE_NAME" -exec rm -f {} \;
