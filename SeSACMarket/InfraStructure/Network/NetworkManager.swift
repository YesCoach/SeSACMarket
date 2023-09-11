//
//  NetworkManager.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

final class NetworkManager: NSObject {

    static let shared = NetworkManager()

    private override init() { }

}

extension NetworkManager {

    func request<T: Codable>(
        api: APIEndPoint.NaverAPI,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url = api.requestURL else {
            return completion(.failure(.invalidURL))
        }

        var request = URLRequest(
            url: url,
            timeoutInterval: 10
        )
        request.httpHeader = APIHeader.NaverAPI.header
        request.httpMethod = "GET"

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)

        dump(request)
        URLSession.request(session, endpoint: request) { (data: T?, error) in
            if let error {
                debugPrint(error)
                return completion(.failure(error))
            }
            guard let data else {
                return completion(.failure(.noData))
            }
            completion(.success(data))
        }
    }

}

extension NetworkManager: URLSessionDelegate {

}
