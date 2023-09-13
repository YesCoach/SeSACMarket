//
//  SearchViewModel.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - Input

protocol SearchViewModelInput {
    func searchShoppingItem(with keyword: String)
    func fetchNextShoppingList()
    func filterDidSelected(with type: APIEndPoint.NaverAPI.QueryType.SortType)
    func likeButtonDidTouched(with data: Goods, isFavorite: Bool)
    func refreshViewController()
    func viewWillAppear()
    func upScrollButtonDidTouched()

    // MARK: SearchBar

    func searchBarTextDidBeginEditing()
    func searchBarTextDidEndEditing()
    func searchBarSearchButtonClicked(text: String)

    // MARK: SearchHistory

    func searchHistoryDelete(index: Int)
    func searchHistoryDidSelect(index: Int)
}

// MARK: - Output

protocol SearchViewModelOutput {
    var itemList: BehaviorSubject<[Goods]> { get }
    var searchHistoryList: BehaviorSubject<[String]> { get }
    var error: PublishRelay<(String?, String?)> { get }
    var isRefreshControlRefreshing: BehaviorRelay<Bool> { get }
    var isFilterViewHidden: BehaviorRelay<Bool> { get }
    var isFilterTypeReset: BehaviorRelay<Bool> { get }
    var isSearchHistoryHidden: BehaviorRelay<Bool> { get }
    var isUpScrollButtonHidden: BehaviorRelay<Bool> { get }
    var isEmptyLabelHidden: BehaviorRelay<Bool> { get }
    var isAlertCalled: BehaviorRelay<Bool> { get }
    var resignKeyboard: BehaviorRelay<Bool> { get }
    var scrollToTopWithAnimation: PublishRelay<Bool> { get }
    var searchBarText: BehaviorRelay<String?> { get }
}

// MARK: -

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {

    // MARK: - UseCase

    private let fetchShoppingUseCase: FetchShoppingUseCase
    private let favoriteShoppingUseCase: FavoriteShoppingUseCase
    private let searchHistoryUseCase: SearchHistoryUseCase

    private let disposeBag = DisposeBag()

    // MARK: DI

    init(
        fetchShoppingUseCase: FetchShoppingUseCase,
        favoriteShoppingUseCase: FavoriteShoppingUseCase,
        searchHistoryUseCase: SearchHistoryUseCase
    ) {
        self.fetchShoppingUseCase = fetchShoppingUseCase
        self.favoriteShoppingUseCase = favoriteShoppingUseCase
        self.searchHistoryUseCase = searchHistoryUseCase
    }

    // MARK: SearchViewModelOutput

    let itemList: BehaviorSubject<[Goods]> = .init(value: [])
    let searchHistoryList: BehaviorSubject<[String]> = .init(value: [])
    let error: PublishRelay<(String?, String?)> = .init()

    // MARK: SearchViewModelUIOutput

    let isRefreshControlRefreshing: BehaviorRelay<Bool> = .init(value: false)
    let isSearchHistoryHidden: BehaviorRelay<Bool> = .init(value: true)
    let isUpScrollButtonHidden: BehaviorRelay<Bool> = .init(value: true)
    let isEmptyLabelHidden: BehaviorRelay<Bool> = .init(value: false)
    let isFilterViewHidden: BehaviorRelay<Bool> = .init(value: true)
    let isFilterTypeReset: BehaviorRelay<Bool> = .init(value: false)
    let isAlertCalled: BehaviorRelay<Bool> = .init(value: false)
    let resignKeyboard: BehaviorRelay<Bool> = .init(value: false)
    let scrollToTopWithAnimation: PublishRelay<Bool> = .init()
    let searchBarText: BehaviorRelay<String?> = .init(value: nil)

    // MARK: Property

    private var dataSourceItemList: [Goods] = []

    private var searchDisplayCount = 30
    private var searchTotalCount: Int?
    private var searchStartIndex = 1
    private var searchKeyword: String?
    private var searchSortType: APIEndPoint.NaverAPI.QueryType.SortType = .sim
    private var isPagingEnabled = false

}

// MARK: - SearchViewModelInput

extension DefaultSearchViewModel {

    // MARK: Search Logic

    /// 새로운 검색어로 검색시 호출합니다.
    /// - Parameter keyword: 검색할 키워드 문자열
    func searchShoppingItem(with keyword: String) {
        let keyword = keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard keyword != "" else {
            error.accept((nil, "검색어는 최소 한글자 이상이여야 해요."))
            return
        }

        isEmptyLabelHidden.accept(true)
        isFilterTypeReset.accept(true)
        searchBarText.accept(keyword)

        // 검색어, 데이터소스 데이터 초기화
        clearData()
        searchKeyword = keyword

        // 검색어를 검색기록에 저장
        saveSearchHistory()
        fetchShoppingList()
    }

    /// 페이징을 위한 프리패칭을 진행합니다.
    /// - 프리패칭 로직
    /// 1. 페이징 플래그 확인
    /// 2. 검색 인덱스가 검색 최대 인덱스를 초과하는지
    /// 3. 검색 인덱스가 검색 결과의 최대 갯수를 초과하는지
    func fetchNextShoppingList() {
        guard isPagingEnabled else { return }
        let nextSearchIndex = searchStartIndex + searchDisplayCount
        guard nextSearchIndex <= Constants.API.searchIdxLimit,
              nextSearchIndex <= searchTotalCount ?? Constants.API.searchIdxLimit
        else { return }

        searchStartIndex += searchDisplayCount
        isPagingEnabled = false

        print("")
        print(#function, ":: is called!!")
        print("=========================")

        fetchShoppingList()
    }

    // MARK: -

    /// 검색의 정렬 기준이 변경될 경우 호출합니다. 매개변수로 받은 값을 통해 패칭을 진행합니다.
    /// - Parameter type: 정렬 기준 타입
    func filterDidSelected(with type: APIEndPoint.NaverAPI.QueryType.SortType) {
        self.searchSortType = type
        self.dataSourceItemList = []
        self.searchStartIndex = 1

        scrollToTopWithAnimation.accept(false)
        fetchShoppingList()
    }

    /// 상품에 좋아요 버튼을 누르면 호출합니다. 좋아요 선택/해제시 데이터베이스에 바로 반영합니다.
    /// 현재 컬렉션뷰에 보여지는 데이터에도 바로 반영합니다.
    /// - Parameters:
    ///   - data: 좋아요를 선택/해제한 상품 정보
    ///   - isFavorite: 좋아요 버튼의 선택값(isSelected)
    func likeButtonDidTouched(with data: Goods, isFavorite: Bool) {
        if isFavorite {
            favoriteShoppingUseCase.enrollFavoriteGoods(goods: data)
        } else {
            favoriteShoppingUseCase.removeFavoriteGoods(goods: data)
        }
        if let index = dataSourceItemList.firstIndex(where: { $0.productID == data.productID }) {
            dataSourceItemList[index].favorite = isFavorite
            itemList.onNext(dataSourceItemList)
        }
    }

    /// 컬렉션뷰를 refresh할 때 호출합니다.
    func refreshViewController() {
        self.searchStartIndex = 1
        fetchShoppingList()
    }

    func viewWillAppear() {
        mappingWithLocalFavoriteData()
        loadSearchHistory()
    }

    // MARK: - SearchBar

    /// 서치바의 입력이 시작될 때 호출합니다.
    func searchBarTextDidBeginEditing() {
        // 입력 상태에 진입하면 검색기록을 보여줘야함
        isSearchHistoryHidden.accept(false)
        isUpScrollButtonHidden.accept(true)
    }

    /// 서치바의 입력이 끝났을때 호출합니다.
    func searchBarTextDidEndEditing() {
        // 입력이 종료되는 케이스
        // 1. 검색하다가 아 검색안해 하고 취소하는 경우
        // 2. 검색 버튼 눌렀을때도 호출된다

        // 해야되는거
        // 검색 상태일때 보여줬던 검색기록 화면 숨기기
        isSearchHistoryHidden.accept(true)
        isUpScrollButtonHidden.accept(false)
    }

    /// 검색 버튼을 클릭하면, 필터타입을 초기화하고 api 콜을 수행합니다.
    /// - Parameter text: 서치바의 텍스트
    func searchBarSearchButtonClicked(text: String) {
        searchShoppingItem(with: text)
        scrollToTopWithAnimation.accept(false)
    }

    /// 검색 기록을 삭제합니다.
    /// - Parameter index: 삭제할 검색 기록의 인덱스
    func searchHistoryDelete(index: Int) {
        var searchHistory: [String] = searchHistoryUseCase.loadSearchHisstory().reversed()
        searchHistory.remove(at: index)
        searchHistoryUseCase.saveSearchHistory(history: searchHistory.reversed())
        loadSearchHistory()
    }

    /// 검색 기록을 선택할때 호출합니다.
    /// - Parameter index: 선택한 검색 기록의 인덱스
    func searchHistoryDidSelect(index: Int) {
        if let searchHistoryList = try? searchHistoryList.value() {
            let keyword = searchHistoryList[index]
            searchShoppingItem(with: keyword)
        }
        resignKeyboard.accept(true)
    }

    /// 스크롤 버튼을 탭했을때 최상단으로 스크롤합니다.
    func upScrollButtonDidTouched() {
        scrollToTopWithAnimation.accept(true)
    }

}

// MARK: - Private Methods

private extension DefaultSearchViewModel {

    /// 검색을 수행합니다.
    /// 추가사항인 쿼리는 뷰모델의 프로퍼티로 가지고 있습니다.
    /// - display: 한번에 보여줄 아이템의 갯수
    /// - start: 검색의 시작점
    /// - sort: 검색결과의 정렬 기준
    func fetchShoppingList() {
        guard let searchKeyword else {
            isRefreshControlRefreshing.accept(false)
            return
        }
        isRefreshControlRefreshing.accept(true)
        fetchShoppingUseCase.fetchShoppingList(
            with: searchKeyword,
            display: searchDisplayCount,
            start: searchStartIndex,
            sort: searchSortType
        ) { [weak self] result in

            print("")
            print(#function, ":: is called!!")
            print("=========================")

            guard let self else { return }
            isRefreshControlRefreshing.accept(false)

            switch result {
            case let .success(searchResult):
                if let itemlist = searchResult.items {
                    if searchStartIndex == 1 {
                        dataSourceItemList = itemlist
                    } else {
                        dataSourceItemList.append(contentsOf: itemlist)
                    }

                    searchTotalCount = searchResult.total
                    mappingWithLocalFavoriteData()

                    isPagingEnabled = true
                    isFilterViewHidden.accept(dataSourceItemList.isEmpty)
                    isUpScrollButtonHidden.accept(dataSourceItemList.isEmpty)
                    isEmptyLabelHidden.accept(!dataSourceItemList.isEmpty)

                    print("")
                    print("✅", #function, ":: is succeed!!")
                    print("=========================")
                }
            case let .failure(error):
                debugPrint(error)
                isPagingEnabled = true
                handleError(error: error)
                return
            }
        }
    }

    /// 좋아요가 저장된 데이터인지 로컬 DB에서 탐색해 처리하고, 매핑된 데이터를 VC에 방출합니다.
    func mappingWithLocalFavoriteData() {
        dataSourceItemList = dataSourceItemList.map {
            var item = $0
            item.favorite = favoriteShoppingUseCase.isFavoriteEnrolled(goods: $0)
            return item
        }
        itemList.onNext(dataSourceItemList)
    }

    /// 현재 검색어를 검색 기록에 저장합니다.
    func saveSearchHistory() {
        var historylist = searchHistoryUseCase.loadSearchHisstory()
        if let searchKeyword {
            historylist.removeAll { $0 == searchKeyword }
            historylist.append(searchKeyword)
        }
        searchHistoryUseCase.saveSearchHistory(history: historylist)
        loadSearchHistory()
    }

    /// 검색 기록을 불러옵니다.
    /// 최근 검색순으로 정렬하기 위해 UserDefaults의 배열을 뒤집어서 방출합니다.
    func loadSearchHistory() {
        searchHistoryList.onNext(searchHistoryUseCase.loadSearchHisstory().reversed())
    }

    /// APIError를 얼럿으로 생성하여 방출합니다.
    func handleError(error: APIError) {
        switch error {
        case .failedRequest, .invalidResponse, .invalidURL:
            let errorTitle = "요청에 실패했습니다"
            let errorMessage = "잠시 후 다시 시도해주세요"
            self.error.accept((errorTitle, errorMessage))
        case .invalidData, .noData:
            return
        }
    }

    /// 뷰모델의 데이터를 초기화합니다.
    /// dataSourceItemList, searchTotalCount, startIndex, keyword, sortType이 초기화됩니다.
    func clearData() {
        dataSourceItemList = []
        searchTotalCount = 0
        searchStartIndex = 1
        searchKeyword = nil
        searchSortType = .sim
    }

}
