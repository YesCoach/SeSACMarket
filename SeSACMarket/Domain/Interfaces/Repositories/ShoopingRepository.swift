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
        query: [APIEndPoint.NaverAPI.QueryType]?,
        completion: @escaping (Result<NaverSearchResult<Goods>, APIError>) -> Void
    )
}
