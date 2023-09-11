//
//  SearchHistory.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

protocol SearchHistoryStorage {
    func saveSearchHistory(searchKey: UserDefaultsKey.SearchHistory, history: [String])
    func loadSearchHistory(keyword: UserDefaultsKey.SearchHistory) -> [String]
}
