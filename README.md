
## 소개
- 개발 기간: 2023.03.26 ~ 2023.04.23
- GitHub가 제공하는 OAuth와 REST API를 사용한 토이 프로젝트입니다.
- 레포지토리 목록 확인, 새로운 레포지토리 생성, Starring 기능을 구현했습니다.

- 실행 방법
  1. [GitHub OAuth App](https://github.com/settings/developers)을 생성하여 Client ID와 Client Secret을 발급받습니다. 
  2. [PropertyList/GitHubClientKey.plist](https://github.com/sanghyeok-kim/MyGitHubTracker/blob/main/MyGitHubTracker/MyGitHubTracker/PropertyList/GitHubClientKey.plist)의 ClientSecret, ClientID에 자신의 키를 입력합니다. 
  3. 로그인 버튼을 눌러 리다이렉션된 GitHub 페이지에서 로그인합니다.

<br>

## 기술 스택

#### DesignPattern & Architecture
- MVVM-C
- Clean Architecture

#### Dependency Injection
- DI Container & Property Wrapper

#### Storage
- KeychainSwift

#### Reactive
- RxSwift
- RxCocoa
- RxAppState
- RxDataSources

#### Layout
- SnapKit
- Then


<br>
<br>


## 스크린 샷
![Group 1 (1)](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/f96c630b-e00a-4597-b83f-747c493aaf77)

<br>
<br>

## 실행 영상

### Login
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/ed802502-c993-4c3d-a5d3-c26cf6fd44b4


### Error Handling
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/05847b4e-1d73-48a1-b0ea-8663d8186554


### Pagination
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/8d1c4b85-a62d-456a-9e58-59dbdbb6bc65


### Starring
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/9eaa7037-8d1d-4961-b70b-58c9471d331e


### Create Repository
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/b404458d-621a-4237-b82e-61a57dbaad62


### Account & Starred Repositories
https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/2300aa82-c85f-4eff-af90-f4f0e7b70680


