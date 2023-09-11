//
//  SearchHistoryRepository.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

protocol SearchHistoryRepository {
    func saveSearchHistory(history: [String])
    func loadSearchHistory() -> [String]
}
