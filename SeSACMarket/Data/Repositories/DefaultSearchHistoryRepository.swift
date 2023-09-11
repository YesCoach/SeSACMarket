//
//  DefaultSearchHistoryRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

final class DefaultSearchHistoryRepository {

    private let historyKey: UserDefaultsKey.SearchHistory
    private let searchHistoryStorage: SearchHistoryStorage

    init(historyKey: UserDefaultsKey.SearchHistory, searchHistoryStorage: SearchHistoryStorage) {
        self.historyKey = historyKey
        self.searchHistoryStorage = searchHistoryStorage
    }

}

extension DefaultSearchHistoryRepository: SearchHistoryRepository {

    func saveSearchHistory(history: [String]) {
        searchHistoryStorage.saveSearchHistory(searchKey: historyKey, history: history)
    }

    func loadSearchHistory() -> [String] {
        return searchHistoryStorage.loadSearchHistory(keyword: historyKey)
    }

}
