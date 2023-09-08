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

    private var searchDisplayCount = 30
    private var searchStartIndex = 0
    private var sortType: APIEndPoint.NaverAPI.QueryType.SortType = .sim

}

// MARK: - SearchViewModel Input

extension DefaultSearchViewModel {
    func searchShoppingItem(with keyword: String) {
        fetchShoppingUseCase.fetchShoppingList(
            with: keyword,
            display: searchDisplayCount,
            start: searchStartIndex,
            sort: sortType
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(searchResult):
                if let items = searchResult.items {
                    dump(items)
                    itemList.onNext(items)
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
