//
//  UserDefaultsSearchHistoryStorage.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

final class UserDefaultsSearchHistoryStorage {

}

extension UserDefaultsSearchHistoryStorage: SearchHistoryStorage {

    func saveSearchHistory(searchKey: UserDefaultsKey.SearchHistory, history: [String]) {
        UserDefaultsManager.searchHistory = history
        switch searchKey {
        case .search: UserDefaultsManager.searchHistory = history
        case .favorite: UserDefaultsManager.likeHistory = history
        }
    }

    func loadSearchHistory(keyword: UserDefaultsKey.SearchHistory) -> [String] {
        return UserDefaultsManager.searchHistory
    }

}
