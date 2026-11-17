#!/usr/bin/env bash
# Firebase Emulator Suite(Auth · Firestore · Functions)를 로컬에서 띄운다.
# UI: http://localhost:4000
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/_java.sh

npm --prefix functions run build
npx --prefix functions firebase emulators:start --project demo-coffeenote --only auth,firestore,functions
