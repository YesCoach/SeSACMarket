//
//  NaverSearchResult.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

// MARK: - NaverSearchResult

struct NaverSearchResult<T> {
    let lastBuildDate: String?
    let total: Int?
    let start: Int?
    let display: Int?
    let items: [T]?
}
