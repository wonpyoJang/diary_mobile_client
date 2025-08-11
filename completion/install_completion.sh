#!/bin/bash

# Flutter 자동완성 설치 스크립트
# 사용법: ./completion/install_completion.sh

echo "🚀 Flutter 자동완성 설치를 시작합니다..."

# 현재 셸 확인
CURRENT_SHELL=$(basename "$SHELL")

# completion 디렉토리 생성
mkdir -p ~/.local/share/flutter_completion

# 자동완성 파일 복사
cp completion/flutter_completion.zsh ~/.local/share/flutter_completion/
cp completion/flutter_completion.bash ~/.local/share/flutter_completion/

# 셸별 설정 파일에 자동완성 추가
if [ "$CURRENT_SHELL" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
    COMPLETION_LINE="source ~/.local/share/flutter_completion/flutter_completion.zsh"
    echo "zsh를 사용하고 있습니다. $CONFIG_FILE에 자동완성을 추가합니다."
elif [ "$CURRENT_SHELL" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
    COMPLETION_LINE="source ~/.local/share/flutter_completion/flutter_completion.bash"
    echo "bash를 사용하고 있습니다. $CONFIG_FILE에 자동완성을 추가합니다."
else
    echo "지원되지 않는 셸입니다: $CURRENT_SHELL"
    echo "수동으로 자동완성을 설정해주세요."
    exit 1
fi

# 이미 설정되어 있는지 확인
if grep -q "flutter_completion" "$CONFIG_FILE"; then
    echo "⚠️  자동완성이 이미 설정되어 있습니다."
else
    # 설정 파일에 자동완성 추가
    echo "" >> "$CONFIG_FILE"
    echo "# Flutter 자동완성" >> "$CONFIG_FILE"
    echo "$COMPLETION_LINE" >> "$CONFIG_FILE"
    echo "✅ $CONFIG_FILE에 자동완성이 추가되었습니다."
fi

# 설치 완료 메시지
echo ""
echo "🎉 Flutter 자동완성 설치가 완료되었습니다!"
echo ""
echo "사용법:"
echo "1. 새 터미널을 열거나 다음 명령어를 실행하세요:"
echo "   source $CONFIG_FILE"
echo ""
echo "2. 또는 다음 명령어로 즉시 활성화할 수 있습니다:"
if [ "$CURRENT_SHELL" = "zsh" ]; then
    echo "   source ~/.local/share/flutter_completion/flutter_completion.zsh"
else
    echo "   source ~/.local/share/flutter_completion/flutter_completion.bash"
fi
echo ""
echo "사용 가능한 별칭:"
echo "  Flutter: f, fg, fr, fb, ft, fc, fd, fa, ff, fu"
echo "  Makefile: mc, mca, mr, mrb, mri, mra, mrm, mrl, mrw, mrwb, mh"
echo ""
echo "자동완성을 테스트하려면 'flutter ' 또는 'make '를 입력하고 Tab을 눌러보세요!"
