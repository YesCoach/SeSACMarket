//
//  SearchViewModel.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchViewModelInput {
    func searchShoppingItem(with keyword: String)
    func prefetchItemsAt(indexPaths: [IndexPath])
    func filterDidSelected(with type: APIEndPoint.NaverAPI.QueryType.SortType)
}

protocol SearchViewModelOutput {
    var itemList: BehaviorSubject<[Goods]> { get }
    var isEmptyLabelHidden: BehaviorRelay<Bool> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {

    private let fetchShoppingUseCase: FetchShoppingUseCase
    private let favoriteShoppingUseCase: FavoriteShoppingUseCase

    // MARK: - DI

    init(
        fetchShoppingUseCase: FetchShoppingUseCase,
        favoriteShoppingUseCase: FavoriteShoppingUseCase
    ) {
        self.fetchShoppingUseCase = fetchShoppingUseCase
        self.favoriteShoppingUseCase = favoriteShoppingUseCase
    }

    // MARK: - SearchViewModel Output

    let itemList: BehaviorSubject<[Goods]> = .init(value: [])
    let isEmptyLabelHidden: BehaviorRelay<Bool> = .init(value: false)

    private var dataSourceItemList: [Goods] = []

    private var searchDisplayCount = 30
    private var searchTotalCount: Int?
    private var searchStartIndex = 1
    private var searchKeyword: String?
    private var sortType: APIEndPoint.NaverAPI.QueryType.SortType = .sim

}

// MARK: - SearchViewModel Input

extension DefaultSearchViewModel {

    /// 새로운 검색어로 검색시 호출합니다.
    /// - Parameter keyword: 검색할 키워드 문자열
    func searchShoppingItem(with keyword: String) {
        // 검색어, 데이터소스 데이터 초기화
        self.searchKeyword = keyword
        self.dataSourceItemList = []
        self.searchStartIndex = 1
        self.sortType = .sim

        fetchShoppingList()
    }

    /// 페이징을 위한 프리패칭을 진행합니다.
    /// - Parameter indexPaths: prefetchItemsAt에서 인자로 받는 indexPaths
    func prefetchItemsAt(indexPaths: [IndexPath]) {
        guard let itemList = try? itemList.value() else { return }

        let nextSearchIndex = searchStartIndex + searchDisplayCount
        guard nextSearchIndex <= Constants.API.searchIdxLimit,
              nextSearchIndex <= searchTotalCount ?? Constants.API.searchIdxLimit
        else { return }

        for indexpath in indexPaths {
            if itemList.count - 2 == indexpath.item {
                searchStartIndex += searchDisplayCount
                fetchShoppingList()
            }
        }
    }

    /// 검색의 정렬 기준이 변경될 경우 호출합니다. 매개변수로 받은 값을 통해 패칭을 진행합니다.
    /// - Parameter type: 정렬 기준 타입
    func filterDidSelected(with type: APIEndPoint.NaverAPI.QueryType.SortType) {
        self.sortType = type
        fetchShoppingList()
    }

}

private extension DefaultSearchViewModel {

    /// 검색을 수행합니다.
    /// 추가사항인 쿼리는 뷰모델의 프로퍼티로 가지고 있습니다.
    /// - display: 한번에 보여줄 아이템의 갯수
    /// - start: 검색의 시작점
    /// - sort: 검색결과의 정렬 기준
    func fetchShoppingList() {
        guard let searchKeyword else { return }
        fetchShoppingUseCase.fetchShoppingList(
            with: searchKeyword,
            display: searchDisplayCount,
            start: searchStartIndex,
            sort: sortType
        ) { [weak self] result in
            print(#function)
            guard let self else { return }
            switch result {
            case let .success(searchResult):
                if let items = searchResult.items {
                    if searchStartIndex == 1 {
                        dataSourceItemList = items
                    } else {
                        dataSourceItemList.append(contentsOf: items)
                    }
                    searchTotalCount = searchResult.total
                    itemList.onNext(dataSourceItemList)
                    isEmptyLabelHidden.accept(!dataSourceItemList.isEmpty)
                    print("✅", #function, "success!!")
                }
            case let .failure(error):
                // TODO: - Network Error Handling
                debugPrint(error)
                return
            }
        }
    }
}
