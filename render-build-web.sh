#!/usr/bin/env bash
# Render Static Site — Build Command: bash render-build-web.sh
# Environment (Render dashboard):
#   FELLOW4U_BASE_URL=https://gkltdd.onrender.com/api

set -euo pipefail

API_URL="${FELLOW4U_BASE_URL:-https://gkltdd.onrender.com/api}"

if [ -z "${FLUTTER_ROOT:-}" ]; then
  FLUTTER_ROOT="${HOME}/flutter"
  if [ ! -d "$FLUTTER_ROOT/bin" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_ROOT"
  fi
fi

export PATH="$FLUTTER_ROOT/bin:$PATH"
flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release --dart-define="FELLOW4U_BASE_URL=${API_URL}"

echo "Web build OK → build/web"
