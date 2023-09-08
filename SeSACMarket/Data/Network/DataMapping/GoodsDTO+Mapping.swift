//
//  GoodsDTO+Mapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

struct GoodsDTO: DTOMapping {
    typealias DomainType = Goods

    let productID: String?
    let title: String
    let link: String?
    let image: String?
    let lowPrice: String?
    let highPrice: String?
    let mallName: String?
    let brand: String?
    let maker: String?

    func toDomain() -> DomainType {
        return .init(
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
