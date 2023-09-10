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
    func likeButtonDidTouched(with data: Goods, isFavorite: Bool)
    func refreshViewController()
    func viewWillAppear()
}

protocol SearchViewModelOutput {
    var itemList: BehaviorSubject<[Goods]> { get }
    var isEmptyLabelHidden: BehaviorRelay<Bool> { get }
    var isAPICallFinished: BehaviorRelay<Bool> { get }
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

    // MARK: - SearchViewModelOutput

    let itemList: BehaviorSubject<[Goods]> = .init(value: [])
    let isEmptyLabelHidden: BehaviorRelay<Bool> = .init(value: false)
    let isAPICallFinished: BehaviorRelay<Bool> = .init(value: true)

    private var dataSourceItemList: [Goods] = []

    private var searchDisplayCount = 30
    private var searchTotalCount: Int?
    private var searchStartIndex = 1
    private var searchKeyword: String?
    private var searchSortType: APIEndPoint.NaverAPI.QueryType.SortType = .sim

}

// MARK: - SearchViewModelInput

extension DefaultSearchViewModel {

    /// 새로운 검색어로 검색시 호출합니다.
    /// - Parameter keyword: 검색할 키워드 문자열
    func searchShoppingItem(with keyword: String) {
        // 검색어, 데이터소스 데이터 초기화
        self.searchKeyword = keyword
        self.dataSourceItemList = []
        self.searchStartIndex = 1
        self.searchSortType = .sim

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
            if itemList.count - 1 == indexpath.item {
                searchStartIndex += searchDisplayCount
                fetchShoppingList()
            }
        }
    }

    /// 검색의 정렬 기준이 변경될 경우 호출합니다. 매개변수로 받은 값을 통해 패칭을 진행합니다.
    /// - Parameter type: 정렬 기준 타입
    func filterDidSelected(with type: APIEndPoint.NaverAPI.QueryType.SortType) {
        self.searchSortType = type
        self.dataSourceItemList = []
        self.searchStartIndex = 1

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
        isAPICallFinished.accept(false)

        fetchShoppingUseCase.fetchShoppingList(
            with: searchKeyword,
            display: searchDisplayCount,
            start: searchStartIndex,
            sort: searchSortType
        ) { [weak self] result in
            print(#function)
            guard let self else { return }
            isAPICallFinished.accept(true)

            switch result {
            case let .success(searchResult):
                if let itemlist = searchResult.items {
                    if searchStartIndex == 1 {
                        dataSourceItemList = itemlist
                    } else {
                        dataSourceItemList.append(contentsOf: itemlist)
                    }
                    searchTotalCount = searchResult.total
                    isEmptyLabelHidden.accept(!dataSourceItemList.isEmpty)
                    mappingWithLocalFavoriteData()
                    print("✅", #function, "success!!")
                }
            case let .failure(error):
                // TODO: - Network Error Handling
                debugPrint(error)
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
}
