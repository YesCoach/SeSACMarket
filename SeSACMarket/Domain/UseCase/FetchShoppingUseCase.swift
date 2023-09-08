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
        sort: String
    ) -> GoodsSearchResult
}

final class DefaultFetchShoppingUseCase {

}

extension DefaultFetchShoppingUseCase: FetchShoppingUseCase {
    func fetchShoppingList(
        with keyword: String,
        display: Int,
        start: Int,
        sort: String
    ) -> GoodsSearchResult {
        let result = GoodsSearchResult(lastBuildDate: nil, total: nil, start: nil, display: nil, items: nil)
        return result
    }
}
