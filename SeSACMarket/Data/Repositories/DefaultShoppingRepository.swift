//
//  DefaultShoppingRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

final class DefaultShoppingRepository {

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }

}

extension DefaultShoppingRepository: ShoppingRepository {
    func searchShoppingItems(
        with keyword: String,
        display: Int,
        start: Int,
        sort: APIEndPoint.NaverAPI.QueryType.SortType,
        completion: @escaping (Result<NaverSearchResult<Goods>, APIError>) -> Void
    ) {
        networkManager.request(
            api: .search(
                type: .shop,
                searchKeyword: keyword,
                query: [
                    .display(count: display),
                    .start(idx: start),
                    .sort(type: sort)
                ]
            )
        ) { (result: Result<NaverSearchResultDTO<GoodsDTO>, APIError>) in
            switch result {
            case let .success(data):
                completion(.success(data.toDomain()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
