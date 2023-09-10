//
//  Goods+Mapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation
import RealmSwift

class GoodsEntity: Object, RealmMapping {
    typealias DomainType = Goods

    @Persisted(primaryKey: true) var productID: String

    @Persisted var title: String
    @Persisted var link: String?
    @Persisted var image: String?
    @Persisted var lowPrice: String?
    @Persisted var highPrice: String?
    @Persisted var mallName: String?
    @Persisted var brand: String?
    @Persisted var maker: String?
    @Persisted var date: Date

    convenience init(
        productID: String,
        title: String,
        link: String?,
        image: String?,
        lowPrice: String?,
        highPrice: String?,
        mallName: String?,
        brand: String?,
        maker: String?
    ) {
        self.init()
        self.productID = productID
        self.title = title
        self.link = link
        self.image = image
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.mallName = mallName
        self.brand = brand
        self.maker = maker
        self.date = Date()
    }

    func toDomain() -> DomainType {
        return DomainType(
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
