#!/usr/bin/env bash

set -e
set -o pipefail

nohup emacs --no-init-file --load           \
  "$NANO_MONKEYTYPE_DIR/monkeytype.el" "$@" \
   &>/dev/null &
