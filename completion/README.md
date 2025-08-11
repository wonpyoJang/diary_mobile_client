# Flutter 프로젝트 자동완성

이 디렉토리는 Flutter 프로젝트 개발을 위한 터미널 자동완성 스크립트들을 포함합니다.

## 🚀 빠른 설치

```bash
# 자동 설치 (권장)
./completion/install_completion.sh

# 또는 수동 설치
source completion/flutter_completion.zsh    # zsh 사용자
source completion/flutter_completion.bash   # bash 사용자
```

## 📁 파일 구조

- `flutter_completion.zsh` - zsh 사용자를 위한 자동완성
- `flutter_completion.bash` - bash 사용자를 위한 자동완성
- `install_completion.sh` - 자동 설치 스크립트
- `README.md` - 이 파일

## ✨ 주요 기능

### Flutter 명령어 자동완성
- `flutter ` + Tab: 모든 Flutter 명령어 표시
- `flutter build ` + Tab: 빌드 타겟 선택
- `flutter run ` + Tab: 실행 모드 선택
- `flutter test ` + Tab: 테스트 옵션 선택
- `flutter pub ` + Tab: pub 명령어 선택

### Makefile 타겟 자동완성
- `make ` + Tab: 모든 Makefile 타겟 표시
- 프로젝트의 커스텀 Makefile 명령어들 지원

### 유용한 별칭들

#### Flutter 명령어
- `f` → `flutter`
- `fg` → `flutter pub get`
- `fr` → `flutter run`
- `fb` → `flutter build`
- `ft` → `flutter test`
- `fc` → `flutter clean`
- `fd` → `flutter doctor`
- `fa` → `flutter analyze`
- `ff` → `flutter format`
- `fu` → `flutter upgrade`

#### Makefile 명령어
- `mc` → `make clean`
- `mca` → `make clean-all`
- `mr` → `make regenerate`
- `mrb` → `make regenerate-build-runner`
- `mri` → `make regenerate-ios`
- `mra` → `make regenerate-android`
- `mrm` → `make regenerate-macos`
- `mrl` → `make regenerate-linux`
- `mrw` → `make regenerate-windows`
- `mrwb` → `make regenerate-web`
- `mh` → `make help`

## 🔧 사용법

### 1. 자동완성 사용
```bash
# Flutter 명령어 자동완성
flutter [Tab]           # 모든 명령어 표시
flutter build [Tab]      # 빌드 타겟 선택
flutter run [Tab]        # 실행 모드 선택

# Makefile 타겟 자동완성
make [Tab]               # 모든 타겟 표시
```

### 2. 별칭 사용
```bash
# Flutter 명령어
fg                      # flutter pub get
fr                      # flutter run
fb apk                  # flutter build apk

# Makefile 명령어
mc                      # make clean
mr                      # make regenerate
mri                     # make regenerate-ios
```

## 🛠️ 수동 설정

### zsh 사용자
```bash
# ~/.zshrc에 추가
source ~/path/to/your/project/completion/flutter_completion.zsh
```

### bash 사용자
```bash
# ~/.bashrc에 추가
source ~/path/to/your/project/completion/flutter_completion.bash
```

## 🔄 업데이트

자동완성을 업데이트하려면:

```bash
# 프로젝트 디렉토리에서
git pull origin main
./completion/install_completion.sh
```

## 🐛 문제 해결

### 자동완성이 작동하지 않는 경우
1. 셸 설정 파일이 올바르게 로드되었는지 확인
2. `source ~/.zshrc` 또는 `source ~/.bashrc` 실행
3. 새 터미널 창 열기

### 특정 명령어가 자동완성되지 않는 경우
1. Flutter가 올바르게 설치되어 있는지 확인
2. `flutter doctor` 실행하여 환경 점검
3. 프로젝트 디렉토리에서 실행하고 있는지 확인

## 📝 참고사항

- 이 자동완성은 Flutter 3.0+ 버전을 기준으로 작성되었습니다
- macOS, Linux, Windows에서 모두 작동합니다
- zsh와 bash를 지원합니다
- 프로젝트의 Makefile과 연동되어 작동합니다

## 🤝 기여하기

자동완성을 개선하거나 새로운 기능을 추가하고 싶다면:

1. 이슈를 생성하여 제안사항을 알려주세요
2. Pull Request를 보내주세요
3. 새로운 Flutter 명령어나 옵션이 추가되면 알려주세요
