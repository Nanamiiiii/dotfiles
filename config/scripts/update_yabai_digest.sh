#!/bin/sh
echo "nanami ALL=(root) NOPASSWD: sha256:e061efc05a9571cd18728331ecb65c23a43f5d7675dc2f2e9b2b9977c5b93751 /opt/homebrew/bin/yabai --load-sa" | sudo tee /etc/sudoers.d/yabai

