# SeSAC Market

![새싹마켓](https://github.com/YesCoach/SeSACMarket/assets/59643667/ba44dc0c-a364-4ffa-a3a7-bd3b210bb671)


### 개발기간

-   23.9.7 ~ 23.9.11

### 요구사항

-   네이버 쇼핑 API를 이용한 상품 검색 및 페이지네이션 기능
-   데이터베이스를 활용한 좋아요 추가/제거 기능(동기화)
-   데이터베이스를 활용한 좋아요 상품 리스트 검색

### 🤔 추가적으로 고려해야 하는 포인트

-   사용자의 환경에 대응하기(네트워크 연결 불안정, 비행기 모드 등)
-   셀 이미지 지연로딩 대응하기

## 📚 기술스택

-   **UIKit, Codebase UI, AutoLayout**
-   **MVVM, CleanArchitecture, Repository, DIContainer, Coordinator**
-   **Realm, RxSwift**
-   **Kingfisher, SnapKit**
-   **URLSession**, **DiffableDataSource**

## **🛎️ 회고**

### 🙆‍♂️ 괜찮았던 점

-   **ViewModel, UseCase, Repository 추상화, 의존성 주입**
-   **요구사항외 추가 기능 구현** (다크모드, 최근검색기록, scroll to top 버튼 등)
-   학습했던 **Compositional Layout**과 **DiffableDataSource**를 프로젝트에 적용하는 과정과 얻을 수 있었던 이점(Dynamic Height, reload animation 등)
-   **서비스적 고려사항 대응**
    -   네트워크 미연결, 또는 API 통신 실패 대응(얼럿)
    -   서치바, 데이터 이미지에 대한 placeholder 처리
    -   UX적인 부분(정렬 버튼 탭시 최상단 스크롤, 네트워크 요청시 인디케이터 처리 등)
-   **이미지 리소스 및 지연로딩 대응**
    -   Kingfisher의 이미지 캐싱, 다운샘플링 기능 사용
    -   셀 재사용시 Kingfisher의 이미지 다운로드 스트림의 초기화로 지연로딩 대응
-   **final** 키워드를 사용한 컴파일 최적화
-   **접근제어자**를 활용한 타입 은닉화, 결합도 감소

### 🤔 아쉬웠던 점

-   **DIContainer** 내부에서 컴포넌트 분리작성의 필요성

    -   모든 의존성 주입을 DIContainer에서 해주고 있는데, 서비스 규모가 커지면 그만큼 DIContainer의 볼륨도 커지게 된다.
    -   만약 일부 뷰모델에서 의존하는 UseCase가 추가되면, 하나의 변경에도 DIContainer 파일 전체가 다시 빌드되기 때문에 컴파일 속도가 증가하게 될 것이다.

    >   코디네이터 패턴을 공부하면서 DIContainer를 Scene별로 분리했다. 확실히 하나의 파일에서 프로젝트의 모든 의존성 주입을 할 경우 수정될때마다 모든 코드가 다시 빌드되기 때문에 컴파일 속도가 증가하므로, Scene별로 나누는것이 좋을 듯 하다! 

-   **비즈니스 로직의 분리가 미흡**

    -   뷰모델에서 비즈니스 로직을 분리하기 위한 계층이 UseCase가 될텐데, 프로젝트에서는 대부분의 비즈니스 로직을 뷰모델에서 하고 있다.
    -   비즈니스 로직을 뷰모델에서 UseCase로 최대한 분리하는 고민이 필요!

-   **타입어노테이션과 .init을 이용한 초기화는 성능이 제일 안좋다**

    -   전혀 생각하지 못했던 이슈였다. 앞으로 사용에 주의...!

        https://forums.swift.org/t/regarding-swift-type-inference-compile-time-performance/49748/6

-   **시간 복잡도를 고려한 효율적인 로직 짜기**

    -   비즈니스 로직 중 선형 시간복잡도를 가진 코드가 여러번 반복되어 사용되는 부분이 있었다. 실제로 앱을 사용하면서 끊김현상이 발생했는데, 선형 시간복잡도가 중첩되는 부분은 구조적으로, 알고리즘적으로 개선해나가는 것이 필요하다...!

## 🎯 트러블 슈팅

### API를 통해 이미지를 받아서 스크롤뷰에 보여주는 과정에서 발생하는 셀 이미지 지연로딩 문제 해결

1.   **이미지 데이터 다운 샘플링 + 캐싱**

     ```swift
     if let imageURLString = data.image, let imageURL = URL(string: imageURLString) {
         thumbnailImageView.kf.setImage(
             with: imageURL,
             placeholder: UIImage(),
             options: [
                 .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))),
                 .scaleFactor(UIScreen.main.scale),
                 .cacheOriginalImage
             ],
             completionHandler: nil
         )
     }
     ```

     Kingfisher의 이미지 캐싱 기능과 다운샘플링 로직을 활용해서 이미지 데이터 패칭 리소스를 최소화 할 수 있었다.

2.   **샐 재사용시 이미지 다운로드 스트림의 초기화**

     ```swift
         override func prepareForReuse() {
             super.prepareForReuse()
             thumbnailImageView.image = nil
             thumbnailImageView.kf.cancelDownloadTask()
             completion = nil
             data = nil
             likeButton.isSelected = false
         }
     
     ```

     셀 재사용시 기존의 이미지 다운로드 관련 스트림을 취소하여 지연로딩 관련 이미지 문제를  해결 할 수 있었다.

### CollectionView 페이징시 스크롤 멈춘 현상 해결

-   페이징시 발생하는 네트워크 비동기 패칭 시간 동안, 인디케이터를 통해 사용자에게 로딩 상태를 표시하고자 하였다. 하지만 적용 이후 스크롤시, 페이징 되는 시점에 스크롤이 멈추는 현상을 발견했다. 

-   문제 원인은 Indicator가 아닌 RefreshControl을 사용했기 때문이였다. 당시 ActivityIndicatorView와 RefreshControl을 모두 알고 있었지만, 로딩중인 상태 표시를 위한 기능에 집중하다 보니 큰 고민 없이 RefreshControl을 사용하게 되었다. 하지만 RefreshControl은 이름 그대로 새로고침할때 사용하는 UIControl 타입의 컴포넌트이다. 진행상태표시를 위해 사용되는 ActivityIndicator와는 별개의 기능일 뿐더러, RefreshControl은 ScrollView와 함께 동작하기 때문에 페이징마다 스크롤이 멈췄던 것이다..! 

-   간단하고 어처구니 없는 코드일 수 있지만 디버깅하는 과정이 생각보다 오래걸렸고, 그 결론과 느낀점을 간단하게 블로그로 정리했다..!

    https://yescoachios.tistory.com/16
