//
//  FavoriteShoppingUseCase.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

protocol FavoriteShoppingUseCase {
    func enrollFavoriteGoods(goods: Goods)
    func readFavoriteGoodsData() -> [Goods]
    func removeFavoriteGoods(goods: Goods)
    func isFavoriteEnrolled(goods: Goods) -> Bool
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
    func readFavoriteGoodsData() -> [Goods] {
        return localShoppingRepository.readGoodsData()
    }
    func removeFavoriteGoods(goods: Goods) {
        return localShoppingRepository.deleteGoodsData(goods: goods)
    }
    func isFavoriteEnrolled(goods: Goods) -> Bool {
        return localShoppingRepository.isFavoriteEnrolled(goods: goods)
    }
}
