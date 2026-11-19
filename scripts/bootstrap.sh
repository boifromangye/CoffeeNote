#!/usr/bin/env bash
# 처음 클론했을 때 한 번 실행: Xcode 프로젝트 생성 + Functions 의존성 설치
set -euo pipefail
cd "$(dirname "$0")/.."

command -v xcodegen >/dev/null || { echo "xcodegen이 필요합니다: brew install xcodegen"; exit 1; }
xcodegen generate
npm --prefix functions ci
echo "준비 완료: open CoffeeNote.xcodeproj"
