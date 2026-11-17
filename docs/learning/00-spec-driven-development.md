# 00. Spec-Driven Development로 일하는 법

## 개념
**스펙이 코드보다 먼저다.** 무엇을 만들지(스펙), 어떻게 확인할지(테스트 계획)를 먼저 확정하고, 코드는 그 테스트를 통과시키는 수단으로 쓴다. 이 프로젝트에서는 문서 4개가 서로를 가리킨다.

```
specification (결정 D*, 규칙 R*) ──▶ test-plan (TST-*) ──▶ 코드 + 테스트
        ▲                                                 │
        └──────── 스펙과 다르면 멈추고 스펙을 먼저 고친다 ◀──┘
```

## 한 기능을 만드는 순서
1. 스펙에서 규칙을 찾는다. 예: R1 D+N 계산.
2. test-plan에서 그 규칙의 테스트 ID를 찾는다. 예: TST-R1-01~05.
3. **테스트를 먼저 쓰고 실패하는 것을 확인한다(Red).**
4. 테스트를 통과하는 가장 단순한 코드를 쓴다(Green).
5. 코드를 다듬는다(Refactor). 테스트는 계속 통과해야 한다.
6. PR에 "통과한 테스트 ID"를 적는다.

이 Red → Green → Refactor 순환을 **TDD(Test-Driven Development)**라고 한다.

## 스펙에 없는 걸 만나면?
임의로 정하지 않는다. 질문을 남기고, 결정되면 스펙의 결정 로그(D*)를 먼저 고치고 버전을 올린다. "코드가 곧 스펙"이 되는 걸 막기 위해서다.

## 더 읽을거리
- Kent Beck, *Test-Driven Development: By Example*
- Martin Fowler, [Specification by Example](https://martinfowler.com/bliki/SpecificationByExample.html)
