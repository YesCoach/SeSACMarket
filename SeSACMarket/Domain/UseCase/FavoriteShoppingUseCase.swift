//
//  FavoriteShoppingUseCase.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

protocol FavoriteShoppingUseCase {
    func enrollFavoriteGoods(goods: Goods)
    func removeFavoriteGoods(goods: Goods)
    func readFavoriteGoodsData() -> [Goods]
    func isFavoriteEnrolled(goods: Goods) -> Bool
    func searchFavoriteGoods(keyword: String) -> [Goods]
}

final class DefaultFavoriteShoppingUseCase {

    private let localShoppingRepository: LocalShoppingRepository

    init(localShoppingRepository: LocalShoppingRepository) {
        self.localShoppingRepository = localShoppingRepository
    }

}

extension DefaultFavoriteShoppingUseCase: FavoriteShoppingUseCase {

    func enrollFavoriteGoods(goods: Goods) {
        localShoppingRepository.createGoodsData(goods: goods)
    }

    func removeFavoriteGoods(goods: Goods) {
        return localShoppingRepository.deleteGoodsData(goods: goods)
    }

    func readFavoriteGoodsData() -> [Goods] {
        return localShoppingRepository.readGoodsData()
    }

    func isFavoriteEnrolled(goods: Goods) -> Bool {
        return localShoppingRepository.isFavoriteEnrolled(goods: goods)
    }

    func searchFavoriteGoods(keyword: String) -> [Goods] {
        return localShoppingRepository.searchGoodsData(keyword: keyword)
    }
}
