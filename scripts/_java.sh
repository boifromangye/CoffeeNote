# Firestore Emulator는 Java 11 이상이 필요하다. JAVA_HOME이 없으면 macOS의 java_home으로 찾는다.
if [[ -z "${JAVA_HOME:-}" ]] && [[ -x /usr/libexec/java_home ]]; then
  JAVA_HOME="$(/usr/libexec/java_home -v 21 2>/dev/null || /usr/libexec/java_home 2>/dev/null || true)"
  export JAVA_HOME
fi
[[ -n "${JAVA_HOME:-}" ]] && export PATH="$JAVA_HOME/bin:$PATH"
command -v java >/dev/null || { echo "Java가 필요합니다(JDK 21 권장)."; exit 1; }
