// Phase 0 하네스 확인용 테스트: Emulator가 떠 있고 규칙이 로드되는지만 본다.
// 📘 학습: @firebase/rules-unit-testing은 Emulator에 "가짜 로그인 사용자"를 만들어
// 보안 규칙이 허용/거부하는지 검사한다. Phase 2의 TST-S01~S11도 이 방식으로 쓴다.
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import {
  assertFails,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc } from "firebase/firestore";
import { afterAll, beforeAll, describe, it } from "vitest";

let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-coffeenote",
    firestore: {
      rules: readFileSync(resolve(__dirname, "../../firestore.rules"), "utf8"),
    },
  });
});

afterAll(async () => {
  await env?.cleanup();
});

describe("Phase 0 규칙 하네스", () => {
  it("로그인하지 않은 사용자는 사용자 문서를 읽을 수 없다", async () => {
    const db = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, "users/someone")));
  });
});
