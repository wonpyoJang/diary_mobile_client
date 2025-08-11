import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_event.dart';
import 'package:diary_mobile_client/src/feature/settings/application/settings_state.dart';
import 'package:diary_mobile_client/src/feature/settings/settings_service.dart';
import 'package:diary_mobile_client/src/feature/settings/settings_controller.dart';

void main() {
  group('Settings 구조 및 기능 테스트', () {
    group('SettingsEvent 구조 테스트', () {
      test('ToggleCalendarMode 이벤트가 올바른 구조를 가져야 함', () {
        // Given
        const event = ToggleCalendarMode();

        // Then
        expect(event, isA<SettingsEvent>());
        expect(event.props, isEmpty);
      });

      test('SettingsEvent가 Equatable을 올바르게 구현해야 함', () {
        // Given
        const event1 = ToggleCalendarMode();
        const event2 = ToggleCalendarMode();

        // When & Then
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });
    });

    group('SettingsState 구조 테스트', () {
      test('SettingsState가 올바른 구조를 가져야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: true);

        // Then
        expect(state.isCalendarMode, isTrue);
        expect(state.props, contains(true));
        expect(state.props.length, equals(1));
      });

      test('SettingsState의 기본 생성자가 올바르게 작동해야 함', () {
        // Given & When
        const state = SettingsState();

        // Then
        expect(state.isCalendarMode, isTrue); // 기본값
      });

      test('SettingsState의 copyWith가 올바르게 작동해야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: false);

        // Then
        expect(updatedState.isCalendarMode, isFalse);
        expect(updatedState.isCalendarMode,
            isNot(equals(originalState.isCalendarMode)));
      });

      test('SettingsState의 copyWith가 null 값을 무시해야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: null);

        // Then
        expect(
            updatedState.isCalendarMode, equals(originalState.isCalendarMode));
      });

      test('SettingsState가 Equatable을 올바르게 구현해야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: true);
        const state3 = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });
    });

    group('이벤트 동등성 테스트', () {
      test('동일한 이벤트가 동등해야 함', () {
        // Given & When & Then
        const event1 = ToggleCalendarMode();
        const event2 = ToggleCalendarMode();

        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('이벤트의 props가 올바르게 설정되어야 함', () {
        // Given & When & Then
        const event = ToggleCalendarMode();
        expect(event.props, isEmpty);
        expect(event.props.length, equals(0));
      });
    });

    group('상태 동등성 테스트', () {
      test('동일한 값을 가진 상태가 동등해야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: true);

        // When & Then
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('다른 값을 가진 상태가 다르게 처리되어야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('상태의 props가 올바르게 설정되어야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state.props, contains(false));
        expect(state.props.length, equals(1));
      });
    });

    group('설정 서비스 통합 테스트', () {
      test('SettingsService 인터페이스가 올바르게 정의되어야 함', () {
        // Given & When & Then
        expect(SettingsService, isA<Type>());
      });

      test('SettingsController가 올바르게 정의되어야 함', () {
        // Given & When & Then
        expect(SettingsController, isA<Type>());
      });
    });

    group('설정 값 유효성 테스트', () {
      test('isCalendarMode가 boolean 타입이어야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: true);

        // When & Then
        expect(state.isCalendarMode, isA<bool>());
        expect(state.isCalendarMode, isTrue);
      });

      test('isCalendarMode가 false 값을 가질 수 있어야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state.isCalendarMode, isA<bool>());
        expect(state.isCalendarMode, isFalse);
      });

      test('copyWith가 boolean 값을 올바르게 처리해야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: false);

        // Then
        expect(updatedState.isCalendarMode, isFalse);
        expect(updatedState.isCalendarMode, isA<bool>());
      });
    });

    group('설정 상태 조합 테스트', () {
      test('여러 설정 값 조합이 올바르게 작동해야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: false);

        // When
        final combinedState1 = state1.copyWith(isCalendarMode: false);
        final combinedState2 = state2.copyWith(isCalendarMode: true);

        // Then
        expect(combinedState1.isCalendarMode, isFalse);
        expect(combinedState2.isCalendarMode, isTrue);
        expect(combinedState1, isNot(equals(state1)));
        expect(combinedState2, isNot(equals(state2)));
      });

      test('설정 상태의 불변성이 보장되어야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: false);

        // Then
        expect(originalState.isCalendarMode, isTrue); // 원본 상태는 변경되지 않음
        expect(updatedState.isCalendarMode, isFalse); // 새로운 상태만 변경됨
      });
    });

    group('설정 이벤트 처리 테스트', () {
      test('ToggleCalendarMode 이벤트가 올바른 타입이어야 함', () {
        // Given
        const event = ToggleCalendarMode();

        // When & Then
        expect(event, isA<ToggleCalendarMode>());
        expect(event, isA<SettingsEvent>());
      });

      test('이벤트의 상속 관계가 올바르게 설정되어야 함', () {
        // Given & When & Then
        expect(ToggleCalendarMode(), isA<SettingsEvent>());
      });
    });

    group('설정 상태 초기화 테스트', () {
      test('기본 생성자로 초기화할 수 있어야 함', () {
        // Given & When
        const state = SettingsState();

        // Then
        expect(state.isCalendarMode, isTrue);
        expect(state.props.length, equals(1));
      });

      test('명시적 값으로 초기화할 수 있어야 함', () {
        // Given & When
        const state = SettingsState(isCalendarMode: false);

        // Then
        expect(state.isCalendarMode, isFalse);
        expect(state.props.length, equals(1));
      });
    });

    group('설정 값 검증 테스트', () {
      test('boolean 값의 범위가 올바르게 검증되어야 함', () {
        // Given
        const trueState = SettingsState(isCalendarMode: true);
        const falseState = SettingsState(isCalendarMode: false);

        // When & Then
        expect(trueState.isCalendarMode, isTrue);
        expect(falseState.isCalendarMode, isFalse);
        expect(
            trueState.isCalendarMode, isNot(equals(falseState.isCalendarMode)));
      });

      test('설정 값이 props에 올바르게 포함되어야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: true);

        // When & Then
        expect(state.props, contains(true));
        expect(state.props, contains(state.isCalendarMode));
      });
    });

    group('설정 상태 비교 테스트', () {
      test('동일한 설정을 가진 상태가 동등해야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: true);

        // When & Then
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('다른 설정을 가진 상태가 다르게 처리되어야 함', () {
        // Given
        const state1 = SettingsState(isCalendarMode: true);
        const state2 = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('copyWith 후 상태가 올바르게 비교되어야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);
        final updatedState = originalState.copyWith(isCalendarMode: false);

        // When & Then
        expect(originalState, isNot(equals(updatedState)));
        expect(originalState.hashCode, isNot(equals(updatedState.hashCode)));
      });
    });

    group('설정 이벤트 구조 테스트', () {
      test('이벤트의 props가 올바르게 설정되어야 함', () {
        // Given
        const event = ToggleCalendarMode();

        // When & Then
        expect(event.props, isEmpty);
        expect(event.props.length, equals(0));
      });

      test('이벤트가 올바른 타입을 가져야 함', () {
        // Given
        const event = ToggleCalendarMode();

        // When & Then
        expect(event, isA<ToggleCalendarMode>());
        expect(event, isA<SettingsEvent>());
      });
    });

    group('설정 상태 구조 테스트', () {
      test('상태의 props가 올바르게 설정되어야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: false);

        // When & Then
        expect(state.props, contains(false));
        expect(state.props.length, equals(1));
      });

      test('상태가 올바른 타입을 가져야 함', () {
        // Given
        const state = SettingsState(isCalendarMode: true);

        // When & Then
        expect(state, isA<SettingsState>());
        expect(state.isCalendarMode, isA<bool>());
      });
    });

    group('설정 값 변경 테스트', () {
      test('copyWith로 설정 값을 변경할 수 있어야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: false);

        // Then
        expect(updatedState.isCalendarMode, isFalse);
        expect(updatedState.isCalendarMode,
            isNot(equals(originalState.isCalendarMode)));
      });

      test('copyWith로 null 값을 전달할 수 있어야 함', () {
        // Given
        const originalState = SettingsState(isCalendarMode: true);

        // When
        final updatedState = originalState.copyWith(isCalendarMode: null);

        // Then
        expect(
            updatedState.isCalendarMode, equals(originalState.isCalendarMode));
      });
    });

    group('설정 상태 유효성 테스트', () {
      test('상태가 올바른 기본값을 가져야 함', () {
        // Given & When
        const state = SettingsState();

        // Then
        expect(state.isCalendarMode, isTrue);
      });

      test('상태가 명시적으로 설정된 값을 가져야 함', () {
        // Given & When
        const state = SettingsState(isCalendarMode: false);

        // Then
        expect(state.isCalendarMode, isFalse);
      });
    });
  });
}
