# GitHub로 직군 간 소통하기

이 저장소에서는 **이슈·라벨·PR**을 기본 채널로 삼고, 직군이 겹치는 일은 **링크와 라벨**로 추적합니다.

## 직군 라벨 (`role/*`)

| 라벨 | 용도 |
|------|------|
| `role/engineering` | 개발·엔지니어링 |
| `role/business` | 비즈니스 전략·수익·제휴 |
| `role/growth` | 그로스·마케팅·ASO·실험 |
| `role/product` | 기획·디자인·UX |

**필터 예**: Issues에서 `label:role/engineering` 검색.

라벨은 저장소에 등록되어 있습니다. 로컬에서 다시 만들 때는:

```bash
gh label create "role/engineering" --color "1D76DB" --description "개발·엔지니어링(버그·기능·리팩터·CI)"
gh label create "role/business" --color "5319E7" --description "비즈니스 전략·수익·로드맵·제휴"
gh label create "role/growth" --color "0E8A16" --description "그로스·마케팅·ASO·캠페인"
gh label create "role/product" --color "FBCA04" --description "기획·디자인·UX·카피(제품)"
```

## 이슈 만들 때

1. **New issue** → 템플릿 선택: 개발 / 비즈니스 / 그로스 / 기획·디자인.
2. 제목 접두사(`[dev]`, `[biz]` 등)는 템플릿 기본값을 유지하거나 팀 규칙에 맞게 수정.
3. **다른 직군에게 넘길 때**: 새 이슈를 열고 서로 **본문에 `#번호`로 링크**하거나, Sub-issues(저장소에서 켜져 있다면)로 연결.

## 영역·우선순위 라벨

기능 도메인은 기존 `area/*`, 우선순위는 `priority/*`, 상태는 `status/*`를 개발 이슈와 함께 쓰면 됩니다.

## 장기 전략 문서 (참고용 본문)

- 비즈니스: `.github/business-strategy-issue-body.md` — [이슈 #38](https://github.com/wonpyoJang/diary_mobile_client/issues/38)
- 그로스: `.github/growth-strategy-issue-body.md`

내용을 바꾼 뒤 **전용 이슈에 댓글**로 diff 요약을 남기면 직군 전체가 같은 스레드를 볼 수 있습니다.

## PR에서

- 본문에 `Closes #`, `Related to #`로 이슈 연결.
- 비기술 이해관계자에게 필요하면 PR 설명에 **무엇이 사용자에게 바뀌는지** 한 단락 요약.

## Discussions

조직 정책상 **GitHub Discussions**를 켤 수 있으면, “아이디어·잡담·FAQ”는 Discussions, **결정·작업 추적**은 Issues로 나누는 구성을 권장합니다.

## 에이전트·로컬 문서

- Cursor: `.cursor/agents/business-team.md`
- Claude Code: `.claude/agents/business-team.md`

직군 역할 정의는 위 파일과 동일하며, **실제 협업 기록은 GitHub 이슈가 단일 소스**입니다.
