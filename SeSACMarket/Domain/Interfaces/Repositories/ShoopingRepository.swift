//
//  ShoopingRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

protocol ShoppingRepository {
    func searchShoppingItems(
        with keyword: String,
        display: Int,
        start: Int,
        sort: APIEndPoint.NaverAPI.QueryType.SortType,
        completion: @escaping (Result<NaverSearchResult<Goods>, APIError>) -> Void
    )
}
