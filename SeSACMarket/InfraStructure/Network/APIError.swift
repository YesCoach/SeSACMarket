//
//  APIError.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import Foundation

enum APIError: Error {
    case failedRequest
    case invalidResponse
    case invalidData
    case invalidURL
    case noData
}
