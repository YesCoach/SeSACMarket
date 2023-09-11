//
//  UserDefaultsManager.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

enum UserDefaultsKey {

    enum SearchHistory: String {
        case search
        case favorite
    }

}

final class UserDefaultsManager {

    @UserDefault(key: UserDefaultsKey.SearchHistory.search.rawValue, defaultValue: [])
    /// 검색 기록
    static var searchHistory: [String]

    /// 좋아요 검색 기록
    @UserDefault(key: UserDefaultsKey.SearchHistory.favorite.rawValue, defaultValue: [])
    static var likeHistory: [String]
}
