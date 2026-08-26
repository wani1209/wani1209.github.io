# 콘텐츠 작성 규칙

이 문서는 GitHub Pages의 기본 Jekyll 빌드를 기준으로 합니다. `_posts` 아래의 포스트는 하위 디렉토리를 포함해 자동으로 탐색되며, 포스트 URL의 `:categories` 값은 폴더명이 아니라 front matter의 `categories`에서 생성됩니다.

## 포스트

### 필드

필수 필드는 `title`, `date`, `categories`입니다. `layout`은 `_config.yml`의 `defaults`가 `post`로 지정하므로 생략할 수 있지만, 문서의 자체 완결성을 위해 명시해도 됩니다.

선택 필드는 `comment`, `published`, `permalink`, `tags`, `description`입니다. `permalink`를 지정하면 기존 URL 정책을 덮어쓰므로 특별한 이유가 없으면 사용하지 않습니다.

| 필드 | 형식 | 설명 |
| --- | --- | --- |
| `layout` | 문자열 | `post` 권장. 기본값은 자동 적용됨 |
| `title` | 문자열 | 포스트 제목 |
| `date` | `YYYY-MM-DD HH:MM:SS +0900` | 게시 시각 |
| `categories` | 문자열 배열 | URL에 순서대로 반영되는 카테고리 |
| `comment` | 불리언 | 댓글 영역 표시 여부. 기본값 `true` |
| `published` | 불리언 | `false`면 게시하지 않음 |
| `permalink` | 문자열 | 개별 URL을 고정할 때만 사용 |
| `tags` | 문자열 배열 | 태그 목록 |
| `description` | 문자열 | 검색/공유용 요약 |

### URL 규칙

현재 설정은 `/:categories/:title`입니다. 따라서 `categories: [Project, Capstone]`인 포스트는 `/Project/Capstone/제목`이 됩니다. 기존 URL의 대소문자를 보존하기 위해 `Project`와 `project`를 임의로 바꾸지 않습니다.

폴더와 카테고리의 불일치를 막으려면 다음처럼 작성합니다.

```text
_posts/Study/2026-08-27-reading.md
categories: [Study]
```

중첩 폴더도 같은 규칙입니다.

```text
_posts/Project/Capstone/2026-08-27-demo.md
categories: [Project, Capstone]
```

저장소의 `scripts/validate_post_categories.rb`가 모든 포스트에 대해 이 규칙을 검사합니다.

### 복사해서 쓰는 템플릿

```yaml
---
layout: post
title: 포스트 제목
date: 2026-08-27 09:00:00 +0900
categories: [Study]
tags: []
comment: true
description: 검색과 공유에 사용할 짧은 요약
---

본문을 여기에 작성합니다.
```

## 페이지

페이지는 프로젝트 루트 또는 하위 디렉토리의 `.html`/`.md` 파일로 작성합니다. `layout`과 `title`은 필수입니다. `permalink`는 페이지 URL을 안정적으로 고정하려면 필수로 지정하는 것을 권장합니다.

선택 필드는 `description`, `parent_category`, `category_key`, `type`입니다. 카테고리 인덱스 페이지는 현재 `type`, 필요하면 `category_key`를 사용해 `archive.html`과 연결합니다.

### 복사해서 쓰는 템플릿

```yaml
---
layout: page
title: About me
permalink: /about/
description: 사이트 운영자 소개
---

페이지 내용을 여기에 작성합니다.
```

## 변경 및 마이그레이션 체크리스트

- 새 폴더를 `_posts` 아래에 만들고, 폴더 경로와 같은 카테고리 값을 front matter 앞부분에 넣습니다.
- 작성 후 `ruby scripts/validate_post_categories.rb`를 실행합니다.
- `permalink`를 추가하거나 카테고리의 대소문자를 바꾸기 전 기존 URL을 확인합니다.
- URL을 바꿔야 한다면 기존 주소를 목록화하고, 각 이전 주소에 `redirect_from`을 쓰는 방식은 GitHub Pages 기본 허용 플러그인 여부를 먼저 확인합니다. 가장 이식성 높은 방법은 이전 경로에 정적 HTML 리다이렉트 페이지를 두는 것입니다.
- 현재 변경은 기존 콘텐츠 파일과 기존 permalink 정책을 수정하지 않으므로 기존 포스트 URL 변경이 없습니다.

## 대안과 선택 이유

현재처럼 카테고리 페이지를 공유하는 구조에서는 표준 `posts`와 front matter 검증이 가장 단순합니다. Jekyll Collections로 폴더별 URL을 강제할 수도 있지만, 컬렉션마다 `_config.yml` 선언과 레이아웃/URL 관리가 필요해 새 디렉토리마다 설정을 추가해야 합니다.

따라서 이 저장소는 표준 `posts`와 front matter 검증을 사용합니다. Jekyll Collections로 전환하면 폴더를 한곳에 모을 수 있지만, 현재 대문자를 포함한 기존 카테고리 URL을 유지하려면 각 문서의 `permalink`가 필요합니다. 또한 `_categories/<이름>/index.html`은 `/:path/` 설정에서 `<이름>/index/index.html`로 출력되므로 이 저장소의 URL 보존 조건과 맞지 않습니다. Collections의 기본 기능과 `output` 설정 자체는 GitHub Pages 기본 빌드에서 별도 플러그인 없이 지원됩니다.