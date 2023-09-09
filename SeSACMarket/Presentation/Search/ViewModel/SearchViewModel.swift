//
//  SearchViewModel.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation
import RxSwift

protocol SearchViewModelInput {
    func searchShoppingItem(with keyword: String)
    func prefetchItemsAt(indexPaths: [IndexPath])
}

protocol SearchViewModelOutput {
    var itemList: BehaviorSubject<[Goods]> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput { }

final class DefaultSearchViewModel: SearchViewModel {

    private let fetchShoppingUseCase: FetchShoppingUseCase

    // MARK: - DI

    init(fetchShoppingUseCase: FetchShoppingUseCase) {
        self.fetchShoppingUseCase = fetchShoppingUseCase
    }

    // MARK: - SearchViewModel Output

    let itemList: BehaviorSubject<[Goods]> = .init(value: [])

    private var dataSourceItemList: [Goods] = []

    private var searchDisplayCount = 30
    private var searchTotalCount: Int?
    private var searchStartIndex = 1
    private var searchKeyword: String?
    private var sortType: APIEndPoint.NaverAPI.QueryType.SortType = .sim

}

// MARK: - SearchViewModel Input

extension DefaultSearchViewModel {
    func searchShoppingItem(with keyword: String) {
        // 검색어, 데이터소스 데이터 초기화
        self.searchKeyword = keyword
        self.dataSourceItemList = []
        self.searchStartIndex = 1

        fetchShoppingList()
    }

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
}

private extension DefaultSearchViewModel {
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
                    dataSourceItemList.append(contentsOf: items)
                    searchTotalCount = searchResult.total
                    itemList.onNext(dataSourceItemList)
                }
            case let .failure(error):
                // TODO: - Network Error Handling
                debugPrint(error)
                itemList.onError(error)
                return
            }
        }
    }
}
