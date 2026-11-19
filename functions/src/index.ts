// 커피콩책 Cloud Functions 진입점.
// Phase 3에서 deleteAccount, prepareAnonymousCleanup, cleanupAnonymous,
// appleServerNotifications를 추가한다(spec 7장). 모든 함수는 asia-northeast3 리전.
import { setGlobalOptions } from "firebase-functions/v2";

setGlobalOptions({ region: "asia-northeast3" });
