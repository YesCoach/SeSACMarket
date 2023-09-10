//
//  GoodsStorage.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

protocol GoodsStorage {
    func createGoodsData(goodsEntity: GoodsEntity)
    func readGoodsData() -> [GoodsEntity]
    func deleteGoodsData(goodsEntity: GoodsEntity)
}
