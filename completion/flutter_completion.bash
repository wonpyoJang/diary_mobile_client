# Flutter 프로젝트 자동완성 스크립트 (Bash)
# 사용법: source completion/flutter_completion.bash

# Flutter 명령어 자동완성
_flutter_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}
    
    case $prev in
        flutter)
            COMPREPLY=( $(compgen -W "analyze build clean config create doctor drive format fuchsia_reload install logs packages precache pub run screenshot test upgrade version" -- "$cur") )
            ;;
        build)
            COMPREPLY=( $(compgen -W "apk appbundle ios macos linux windows web" -- "$cur") )
            ;;
        run)
            COMPREPLY=( $(compgen -W "--debug --profile --release --hot --hot-restart" -- "$cur") )
            ;;
        test)
            COMPREPLY=( $(compgen -W "--coverage --reporter --tags --exclude-tags --timeout" -- "$cur") )
            ;;
        pub)
            COMPREPLY=( $(compgen -W "get upgrade outdated deps deactivate global publish uploader version" -- "$cur") )
            ;;
        *)
            COMPREPLY=( $(compgen -W "analyze build clean config create doctor drive format fuchsia_reload install logs packages precache pub run screenshot test upgrade version" -- "$cur") )
            ;;
    esac
}

# Makefile 타겟 자동완성
_make_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "clean clean-all regenerate regenerate-build-runner regenerate-ios regenerate-android regenerate-macos regenerate-linux regenerate-windows regenerate-web help" -- "$cur") )
}

# 자동완성 등록
complete -F _flutter_completion flutter
complete -F _make_completion make

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

echo "🚀 Flutter 자동완성이 활성화되었습니다! (Bash)"
echo "사용 가능한 별칭: f, fg, fr, fb, ft, fc, fd, fa, ff, fu"
echo "Makefile 별칭: mc, mca, mr, mrb, mri, mra, mrm, mrl, mrw, mrwb, mh"
