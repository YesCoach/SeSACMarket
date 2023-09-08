//
//  FetchShoppingUseCase.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

protocol FetchShoppingUseCase {
    func fetchShoppingList(
        with keyword: String,
        display: Int,
        start: Int,
        sort: APIEndPoint.NaverAPI.QueryType.SortType,
        completion: @escaping (Result<NaverSearchResult<Goods>, APIError>) -> Void
    )
}

final class DefaultFetchShoppingUseCase {

    private let shoppingRepository: ShoppingRepository

    init(shoppingRepository: ShoppingRepository) {
        self.shoppingRepository = shoppingRepository
    }

}

extension DefaultFetchShoppingUseCase: FetchShoppingUseCase {
    func fetchShoppingList(
        with keyword: String,
        display: Int = 30,
        start: Int,
        sort: APIEndPoint.NaverAPI.QueryType.SortType,
        completion: @escaping (Result<NaverSearchResult<Goods>, APIError>) -> Void
    ) {
        shoppingRepository.searchShoppingItems(
            with: keyword,
            query: [.display(count: display), .start(idx: start), .sort(type: sort)]
        ) { result in
            completion(result)
        }
    }
}
