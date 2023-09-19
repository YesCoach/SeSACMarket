//
//  Goods.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

// MARK: - Goods

struct Goods: Hashable {
    let productID: String
    let title: String
    let link: String?
    let image: String?
    let lowPrice: String?
    let highPrice: String?
    let mallName: String?
    let brand: String?
    let maker: String?
    var favorite: Bool = false
}

extension Goods {

    /// 상품 링크 페이지입니다.
    var productURL: URL? {
        return URL(string: "https://msearch.shopping.naver.com/product/\(productID)")
    }

}
