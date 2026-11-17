#!/usr/bin/env bash
# iOS 단위 테스트 실행. 시뮬레이터는 DESTINATION 환경 변수로 바꿀 수 있다.
#   예: DESTINATION='platform=iOS Simulator,name=iPhone SE (3rd generation),OS=17.5' scripts/test-ios.sh
set -euo pipefail
cd "$(dirname "$0")/.."

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=latest}"
xcodegen generate --quiet
xcodebuild test -project CoffeeNote.xcodeproj -scheme CoffeeNote -destination "$DESTINATION"
