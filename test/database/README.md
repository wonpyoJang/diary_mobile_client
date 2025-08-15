# 데이터베이스 테스트

이 디렉토리에는 drift와 로컬 데이터베이스 관련 테스트 파일들이 포함되어 있습니다.

## 테스트 파일 목록

### 1. `database_simple_test.dart`
- 가장 기본적인 데이터베이스 테스트
- 데이터베이스 생성, 연결, 종료 테스트
- MomentTable의 기본 CRUD 작업 테스트
- **실행 방법**: `flutter test test/database/database_simple_test.dart`

### 2. `database_in_memory_test.dart`
- 메모리 내 데이터베이스를 사용하는 종합 테스트
- MomentTable과 EmotionalIntensityTable의 CRUD 작업 테스트
- 트랜잭션 테스트
- 데이터 정합성 테스트
- **실행 방법**: `flutter test test/database/database_in_memory_test.dart`

### 3. `database_test.dart`
- 파일 기반 데이터베이스를 사용하는 고급 테스트
- MediaTable 포함 모든 테이블 테스트
- JOIN 쿼리 테스트
- 외래 키 제약 조건 테스트
- **실행 방법**: `flutter test test/database/database_test.dart`

### 4. `database_migration_test.dart`
- 데이터베이스 마이그레이션 테스트
- 스키마 버전 테스트
- 테이블 구조 테스트
- 성능 테스트
- **실행 방법**: `flutter test test/database/database_migration_test.dart`

### 5. `database_query_test.dart`
- 복잡한 쿼리 테스트
- 날짜 범위 검색
- 감정별 검색
- 집계 함수 테스트
- **실행 방법**: `flutter test test/database/database_query_test.dart`

## 전체 테스트 실행

모든 데이터베이스 테스트를 한 번에 실행하려면:

```bash
flutter test test/database/
```

## 테스트 환경

- **Flutter**: 3.5.4+
- **Drift**: 2.28.1+
- **테스트 프레임워크**: flutter_test

## 주요 테스트 내용

### CRUD 작업 테스트
- **Create**: 데이터 삽입 테스트
- **Read**: 데이터 조회 테스트
- **Update**: 데이터 수정 테스트
- **Delete**: 데이터 삭제 테스트

### 관계형 데이터 테스트
- 외래 키 제약 조건
- 테이블 간 JOIN 쿼리
- 데이터 정합성 검증

### 성능 테스트
- 대량 데이터 삽입
- 쿼리 성능 측정
- 트랜잭션 처리

### 스키마 테스트
- 테이블 구조 검증
- 컬럼 타입 확인
- 제약 조건 검증

## 테스트 데이터

각 테스트는 독립적으로 실행되며, `setUp()`과 `tearDown()` 메서드를 통해 테스트 데이터를 관리합니다.

- 테스트 시작 시: 필요한 테스트 데이터 생성
- 테스트 종료 시: 모든 테스트 데이터 정리
- 메모리 내 데이터베이스 사용으로 테스트 간 격리

## 주의사항

1. **Flutter 바인딩 초기화**: 모든 테스트에서 `TestWidgetsFlutterBinding.ensureInitialized()` 호출
2. **데이터 정리**: 각 테스트 후 데이터베이스 정리 필수
3. **비동기 처리**: `async/await` 사용하여 비동기 작업 처리
4. **예외 처리**: 데이터베이스 오류 상황에 대한 예외 처리 테스트

## 문제 해결

### Flutter 바인딩 오류
```
Binding has not yet been initialized
```
**해결방법**: 테스트 시작 시 `TestWidgetsFlutterBinding.ensureInitialized()` 호출

### 플러그인 오류
```
MissingPluginException
```
**해결방법**: 메모리 내 데이터베이스 사용 또는 테스트 환경 설정

### 외래 키 제약 조건 오류
```
UNIQUE constraint failed
```
**해결방법**: 테스트 데이터 정리 로직 추가
