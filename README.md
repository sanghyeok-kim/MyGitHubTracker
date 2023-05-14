
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

## Wiki

- [Coordinator Pattern](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/%EC%99%9C-Coordinator-Pattern%EC%9D%84-%EC%82%AC%EC%9A%A9%ED%95%98%EB%8A%94%EA%B0%80%3F)

- [DataMapper](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/DataMapper%EB%A5%BC-%ED%86%B5%ED%95%B4-DTO-%E2%86%92-Entity-%EB%B3%80%ED%99%98-%EA%B3%BC%EC%A0%95%EC%9D%98-%EA%B2%B0%ED%95%A9%EB%8F%84-%EB%82%AE%EC%B6%94%EA%B8%B0)

- [DI Container (+ Property Wrapper)](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/DI-Container%EB%A5%BC-%ED%86%B5%ED%95%9C-%EC%9D%98%EC%A1%B4%EC%84%B1-%EB%93%B1%EB%A1%9D-%EB%B0%8F-%EC%A3%BC%EC%9E%85,-Property-Wrapper%EC%9D%98-%ED%99%9C%EC%9A%A9)

- [Materialize](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/Materialize%EB%A5%BC-%ED%99%9C%EC%9A%A9%ED%95%9C-%EC%9D%B4%EB%B2%A4%ED%8A%B8-%EC%B2%98%EB%A6%AC)

- [User Responsiveness](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/Star-%EB%B2%84%ED%8A%BC%EC%9D%98-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%9D%91%EB%8B%B5%EC%84%B1-%EA%B0%9C%EC%84%A0)

- [Caching](https://github.com/sanghyeok-kim/MyGitHubTracker/wiki/Image-Caching%EC%9D%84-%EC%9C%84%ED%95%9C-%EC%BD%94%EB%93%9C-%EB%A6%AC%ED%8C%A9%ED%86%A0%EB%A7%81-%EA%B3%BC%EC%A0%95)


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


