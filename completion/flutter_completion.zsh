# Flutter 프로젝트 자동완성 스크립트
# 사용법: source completion/flutter_completion.zsh

# Flutter 기본 명령어들
_flutter_commands() {
    local -a commands
    commands=(
        'analyze:코드 분석 실행'
        'build:앱 빌드'
        'clean:빌드 캐시 정리'
        'config:Flutter 설정'
        'create:새 프로젝트 생성'
        'doctor:환경 진단'
        'drive:통합 테스트 실행'
        'format:코드 포맷팅'
        'fuchsia_reload:퓨시아 앱 리로드'
        'install:앱 설치'
        'logs:로그 보기'
        'packages:패키지 관리'
        'precache:사전 캐시'
        'pub:패키지 관리'
        'run:앱 실행'
        'screenshot:스크린샷 촬영'
        'test:테스트 실행'
        'upgrade:Flutter 업그레이드'
        'version:버전 정보'
    )
    _describe -t commands 'flutter commands' commands
}

# Makefile 타겟들
_makefile_targets() {
    local -a targets
    targets=(
        'clean:Flutter generated 파일들만 삭제'
        'clean-all:모든 generated 파일과 빌드 캐시 삭제'
        'regenerate:모든 generated 파일 재생성'
        'regenerate-build-runner:build_runner로 생성된 파일만 재생성'
        'regenerate-ios:iOS 전용 재생성'
        'regenerate-android:Android 전용 재생성'
        'regenerate-macos:macOS 전용 재생성'
        'regenerate-linux:Linux 전용 재생성'
        'regenerate-windows:Windows 전용 재생성'
        'regenerate-web:Web 전용 재생성'
        'help:사용 가능한 명령어 표시'
    )
    _describe -t targets 'make targets' targets
}

# Flutter build 타겟들
_flutter_build_targets() {
    local -a targets
    targets=(
        'apk:Android APK 빌드'
        'appbundle:Android App Bundle 빌드'
        'ios:iOS 앱 빌드'
        'macos:macOS 앱 빌드'
        'linux:Linux 앱 빌드'
        'windows:Windows 앱 빌드'
        'web:Web 앱 빌드'
    )
    _describe -t targets 'build targets' targets
}

# Flutter run 모드들
_flutter_run_modes() {
    local -a modes
    modes=(
        '--debug:디버그 모드로 실행'
        '--profile:프로파일 모드로 실행'
        '--release:릴리즈 모드로 실행'
        '--hot:핫 리로드 활성화'
        '--hot-restart:핫 리스타트'
    )
    _describe -t modes 'run modes' modes
}

# Flutter test 옵션들
_flutter_test_options() {
    local -a options
    options=(
        '--coverage:코버리지 리포트 생성'
        '--reporter:테스트 리포터 설정'
        '--tags:특정 태그의 테스트만 실행'
        '--exclude-tags:특정 태그 제외'
        '--timeout:테스트 타임아웃 설정'
    )
    _describe -t options 'test options' options
}

# Flutter pub 명령어들
_flutter_pub_commands() {
    local -a commands
    commands=(
        'get:의존성 설치'
        'upgrade:의존성 업그레이드'
        'outdated:오래된 의존성 확인'
        'deps:의존성 트리 확인'
        'deactivate:패키지 비활성화'
        'global:전역 패키지 관리'
        'publish:패키지 게시'
        'uploader:업로더 관리'
        'version:버전 관리'
    )
    _describe -t commands 'pub commands' commands
}

# Flutter 자동완성 메인 함수
_flutter_completion() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1: :->command' \
        '*: :->args'

    case $state in
        command)
            case $words[1] in
                flutter)
                    _flutter_commands
                    ;;
                make)
                    _makefile_targets
                    ;;
                *)
                    _flutter_commands
                    ;;
            esac
            ;;
        args)
            case $words[1] in
                flutter)
                    case $words[2] in
                        build)
                            _flutter_build_targets
                            ;;
                        run)
                            _flutter_run_modes
                            ;;
                        test)
                            _flutter_test_options
                            ;;
                        pub)
                            _flutter_pub_commands
                            ;;
                        *)
                            _flutter_commands
                            ;;
                    esac
                    ;;
                make)
                    _makefile_targets
                    ;;
            esac
            ;;
    esac
}

# 자동완성 등록
compdef _flutter_completion flutter
compdef _makefile_targets make

# 유용한 별칭들
alias f='flutter'
alias fg='flutter pub get'
alias fr='flutter run'
alias fb='flutter build'
alias ft='flutter test'
alias fc='flutter clean'
alias fd='flutter doctor'
alias fa='flutter analyze'
alias ff='flutter format'
alias fu='flutter upgrade'

# Makefile 별칭들
alias mc='make clean'
alias mca='make clean-all'
alias mr='make regenerate'
alias mrb='make regenerate-build-runner'
alias mri='make regenerate-ios'
alias mra='make regenerate-android'
alias mrm='make regenerate-macos'
alias mrl='make regenerate-linux'
alias mrw='make regenerate-windows'
alias mrwb='make regenerate-web'
alias mh='make help'

echo "🚀 Flutter 자동완성이 활성화되었습니다!"
echo "사용 가능한 별칭: f, fg, fr, fb, ft, fc, fd, fa, ff, fu"
echo "Makefile 별칭: mc, mca, mr, mrb, mri, mra, mrm, mrl, mrw, mrwb, mh"
