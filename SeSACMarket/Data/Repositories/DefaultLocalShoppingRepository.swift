//
//  DefaultLocalShoppingRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

final class DefaultLocalShoppingRepository {

    private let goodsStorage: GoodsStorage

    init(goodsStorage: GoodsStorage) {
        self.goodsStorage = goodsStorage
    }

}

extension DefaultLocalShoppingRepository: LocalShoppingRepository {

    func createGoodsData(goods: Goods) {
        goodsStorage.createGoodsData(goodsEntity: goods.toEntity())
    }

    func readGoodsData() -> [Goods] {
        return goodsStorage.readGoodsData().map { $0.toDomain() }
    }

    func deleteGoodsData(goods: Goods) {
        goodsStorage.deleteGoodsData(goodsEntity: goods.toEntity())
    }

}

extension Goods {

    func toEntity() -> GoodsEntity {
        return GoodsEntity(
            productID: productID,
            title: title,
            link: link,
            image: image,
            lowPrice: lowPrice,
            highPrice: highPrice,
            mallName: mallName,
            brand: brand,
            maker: maker
        )
    }

}
