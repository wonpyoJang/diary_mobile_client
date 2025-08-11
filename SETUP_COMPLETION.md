# 🚀 Flutter 자동완성 설치 가이드

이 프로젝트에는 Flutter 개발을 위한 터미널 자동완성이 포함되어 있습니다.

## ⚡ 빠른 설치

```bash
# 자동 설치 (권장)
./completion/install_completion.sh
```

## 📋 수동 설치

### zsh 사용자
```bash
source completion/flutter_completion.zsh
```

### bash 사용자
```bash
source completion/flutter_completion.bash
```

## ✨ 주요 기능

- **Flutter 명령어 자동완성**: `flutter ` + Tab
- **Makefile 타겟 자동완성**: `make ` + Tab
- **유용한 별칭들**: `f`, `fg`, `fr`, `fb`, `mc`, `mr` 등

## 🔧 사용법

1. **자동완성**: `flutter ` 또는 `make ` 입력 후 Tab 키
2. **별칭 사용**: `fg` (flutter pub get), `mc` (make clean) 등

## 📚 자세한 설명

자세한 사용법과 설정 방법은 `completion/README.md`를 참조하세요.

---

**💡 팁**: 새 터미널을 열거나 `source ~/.zshrc` (zsh) / `source ~/.bashrc` (bash)를 실행하여 자동완성을 활성화하세요!
