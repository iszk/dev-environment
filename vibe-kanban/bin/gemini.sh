#!/bin/bash

# このスクリプトは vibe-kanban コンテナ内で起動される
# docker container をビルドし、gemini CLI を実行する

# スクリプトのエラーで止まるように設定
set -e

# 1. ホスト側のユーザーID / グループID を取得
MY_UID=$(id -u)
MY_GID=$(id -g)

DIR_NAME="$(basename "$(pwd)")"
WORKTREE="/var/tmp/vibe-kanban/worktrees/$DIR_NAME"
IMAGE_NAME="agent-$DIR_NAME"

echo "Building with UID: $MY_UID, GID: $MY_GID..."

docker build -t $IMAGE_NAME \
  --build-arg UID="$MY_UID" \
  --build-arg GID="$MY_GID" \
  agents/

exec docker run --rm -i \
  -v "$WORKTREE:$WORKTREE" \
  -v "/home/yoh/.gemini:/home/agent/.gemini" \
  --group-add $(stat -c '%g' /var/run/docker.sock) \
  $IMAGE_NAME \
  npx -y @google/gemini-cli "$@"
  # bash
