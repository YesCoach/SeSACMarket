//
//  NaverSearchResultDTO+Mapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

struct NaverSearchResultDTO<T: DTOMapping>: DTOMapping {
    typealias DomainType = NaverSearchResult

    var lastBuildDate: String?
    var total: Int?
    var start: Int?
    var display: Int?
    var items: [T]

    func toDomain() -> DomainType<T.DomainType> {
        return .init(
            lastBuildDate: lastBuildDate,
            total: total,
            start: start,
            display: display,
            items: items.map { $0.toDomain() }
        )
    }
}
