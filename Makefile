.PHONY: clean clean-all regenerate regenerate-build-runner help

# 기본 타겟
help:
	@echo "사용 가능한 명령어:"
	@echo "  clean                 - Flutter generated 파일들만 삭제"
	@echo "  clean-all            - 모든 generated 파일과 빌드 캐시 삭제"
	@echo "  regenerate           - 모든 generated 파일 재생성"
	@echo "  regenerate-build-runner - build_runner로 생성된 파일만 재생성"
	@echo "  help                 - 이 도움말 표시"

# Flutter generated 파일들만 삭제
clean:
	@echo "🧹 Flutter generated 파일들 삭제 중..."
	@rm -rf lib/src/database/*.g.dart
	@rm -rf ios/Flutter/Generated.xcconfig
	@rm -rf ios/Flutter/flutter_export_environment.sh
	@rm -rf ios/Runner/GeneratedPluginRegistrant.*
	@rm -rf macos/Flutter/GeneratedPluginRegistrant.*
	@rm -rf macos/Flutter/GeneratedPluginRegistrant.swift
	@rm -rf linux/flutter/generated_plugin_registrant.*
	@rm -rf windows/flutter/generated_plugin_registrant.*
	@rm -rf web/generated_plugin_registrant.*
	@echo "✅ Flutter generated 파일들 삭제 완료"

# 모든 generated 파일과 빌드 캐시 삭제
clean-all: clean
	@echo "🧹 모든 빌드 캐시와 generated 파일 삭제 중..."
	@rm -rf build/
	@rm -rf .dart_tool/
	@rm -rf .flutter-plugins
	@rm -rf .flutter-plugins-dependencies
	@rm -rf ios/Pods/
	@rm -rf ios/Podfile.lock
	@rm -rf macos/Pods/
	@rm -rf macos/Podfile.lock
	@rm -rf android/.gradle/
	@rm -rf android/app/build/
	@rm -rf android/build/
	@rm -rf linux/build/
	@rm -rf windows/build/
	@rm -rf web/build/
	@echo "✅ 모든 빌드 캐시와 generated 파일 삭제 완료"

# 모든 generated 파일 재생성
regenerate: clean-all
	@echo "🔄 Flutter 프로젝트 재생성 중..."
	@flutter clean
	@flutter pub get
	@flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "✅ 모든 generated 파일 재생성 완료"

# build_runner로 생성된 파일만 재생성
regenerate-build-runner:
	@echo "🔄 build_runner로 생성된 파일만 재생성 중..."
	@flutter packages pub run build_runner build --delete-conflicting-outputs
	@echo "✅ build_runner로 생성된 파일 재생성 완료"

# iOS 전용 재생성
regenerate-ios: clean
	@echo "🔄 iOS generated 파일 재생성 중..."
	@cd ios && pod install
	@flutter build ios --no-codesign
	@echo "✅ iOS generated 파일 재생성 완료"

# Android 전용 재생성
regenerate-android: clean
	@echo "🔄 Android generated 파일 재생성 중..."
	@flutter build apk --debug
	@echo "✅ Android generated 파일 재생성 완료"

# macOS 전용 재생성
regenerate-macos: clean
	@echo "🔄 macOS generated 파일 재생성 중..."
	@cd macos && pod install
	@flutter build macos --no-codesign
	@echo "✅ macOS generated 파일 재생성 완료"

# Linux 전용 재생성
regenerate-linux: clean
	@echo "🔄 Linux generated 파일 재생성 중..."
	@flutter build linux --debug
	@echo "✅ Linux generated 파일 재생성 완료"

# Windows 전용 재생성
regenerate-windows: clean
	@echo "🔄 Windows generated 파일 재생성 중..."
	@flutter build windows --debug
	@echo "✅ Windows generated 파일 재생성 완료"

# Web 전용 재생성
regenerate-web: clean
	@echo "🔄 Web generated 파일 재생성 중..."
	@flutter build web --debug
	@echo "✅ Web generated 파일 재생성 완료"
