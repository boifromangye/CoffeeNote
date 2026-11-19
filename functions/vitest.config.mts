import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["test/**/*.test.ts"],
    // Emulator를 공유하므로 테스트 파일을 순서대로 실행한다.
    fileParallelism: false,
    testTimeout: 20_000,
  },
});
