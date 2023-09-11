//
//  SearchHistoryUseCase.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

protocol SearchHistoryUseCase {
    func saveSearchHistory(history: [String])
    func loadSearchHisstory() -> [String]
}

final class DefaultSearchHistoryUseCase {

    private let searchHistroyRepository: SearchHistoryRepository

    init(searchHistroyRepository: SearchHistoryRepository) {
        self.searchHistroyRepository = searchHistroyRepository
    }

}

extension DefaultSearchHistoryUseCase: SearchHistoryUseCase {

    func saveSearchHistory(history: [String]) {
        searchHistroyRepository.saveSearchHistory(history: history)
    }

    func loadSearchHisstory() -> [String] {
        return searchHistroyRepository.loadSearchHistory()
    }

}
