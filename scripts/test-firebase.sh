#!/usr/bin/env bash
# Emulator를 띄운 상태에서 규칙·Functions 테스트를 실행하고 종료한다(CI와 같은 명령).
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/_java.sh

npm --prefix functions run build
npm --prefix functions run typecheck
npm --prefix functions run test:emu
