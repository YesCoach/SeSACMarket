//
//  LocalShoppingRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

protocol LocalShoppingRepository {
    func createGoodsData(goods: Goods)
    func readGoodsData() -> [Goods]
    func isFavoriteEnrolled(goods: Goods) -> Bool
    func searchGoodsData(keyword: String) -> [Goods]
    func deleteGoodsData(goods: Goods)
}
