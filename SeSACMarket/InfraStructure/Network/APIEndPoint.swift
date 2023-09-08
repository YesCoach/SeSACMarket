//
//  APIEndPoint.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

enum APIEndPoint {

    enum NaverAPI {
        case search(type: SearchType, searchKeyword: String, query: [QueryType]?)
    }

}

extension APIEndPoint.NaverAPI {

    enum SearchType {
        case shop
    }

    enum QueryType {
        case display(count: Int)
        case start(idx: Int)
        case sort(type: SortType)

        /// 결과값 정렬 쿼리 타입
        /// - `sim`: 정확도순으로 내림차순 정렬(기본값)
        /// - `date`: 날짜순으로 내림차순 정렬
        /// - `asc`: 가격순으로 오름차순 정렬
        /// - `dsc`: 가격순으로 내림차순 정렬
        enum SortType {
            case sim
            case date
            case asc
            case dsc
        }

        var queryValue: String {
            switch self {
            case .display(let count): return String(count)
            case .start(let idx): return String(idx)
            case .sort(let type): return "\(type)"
            }
        }

        var queryName: String {
            switch self {
            case .display: return "display"
            case .sort: return "sort"
            case .start: return "start"
            }
        }
    }

    static let baseURL = "https://openapi.naver.com/v1/"

    private var urlComponents: URLComponents? {
        switch self {
        case let .search(type, searchKeyword, _):
            return URLComponents(
                string: Self.baseURL + "search/\(type).json?query=\(searchKeyword)"
            )
        }
    }

    var requestURL: URL? {
        var urlComponents = self.urlComponents
        var urlQueryItems: [URLQueryItem] = []

        switch self {
        case let .search( _, _, query):
            if let query {
                urlQueryItems = query.map {
                    URLQueryItem(name: $0.queryName, value: $0.queryValue)
                }
            }
        }
        urlQueryItems.forEach {
            urlComponents?.queryItems?.append($0)
        }
        return urlComponents?.url
    }
}
