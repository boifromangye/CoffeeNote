/// R1. D+N 계산 — 로스팅 후 며칠째에 마셨는지.
///
/// 저장하지 않는 값이다. 원두의 로스팅일을 고치면 화면에서 다시 계산된다.
enum DPlus {
    /// `drankOn - roastDate`(일). 로스팅 당일은 0, 로스팅일이 없으면 nil(배지 없음).
    ///
    /// 음수(마신 날이 로스팅일보다 이름)는 NoteRule `drankBeforeRoast`가 저장을 막는다(R3).
    static func days(drankOn: DateOnly, roastDate: DateOnly?) -> Int? {
        // 📘 학습: Optional.map은 값이 있을 때만 클로저를 실행하고, nil이면 nil을 그대로 돌려준다.
        roastDate.map { drankOn.days(from: $0) }
    }
}
