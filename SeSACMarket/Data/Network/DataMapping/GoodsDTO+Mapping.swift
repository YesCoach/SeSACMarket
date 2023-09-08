//
//  GoodsDTO+Mapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

struct GoodsDTO: DTOMapping {
    typealias DomainType = Goods

    let productId: String?
    let title: String
    let link: String?
    let image: String?
    let lprice: String?
    let hprice: String?
    let mallName: String?
    let brand: String?
    let maker: String?

    func toDomain() -> DomainType {
        let adjustedTitle = title
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")

        return .init(
            productID: productId,
            title: adjustedTitle,
            link: link,
            image: image,
            lowPrice: lprice,
            highPrice: hprice,
            mallName: mallName,
            brand: brand,
            maker: maker
        )
    }
}
