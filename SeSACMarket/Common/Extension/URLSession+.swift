//
//  URLSession+.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import Foundation

extension URLSession {

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    @discardableResult
    func customDataTask(
        _ endPoint: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let task = dataTask(with: endPoint, completionHandler: completionHandler)
        task.resume()

        return task
    }

    static func request<T: Codable>(
        _ session: URLSession = .shared,
        endpoint: URLRequest,
        completion: @escaping ((T?, APIError?) -> Void)
    ) {
        session.customDataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {

                if let error {
                    debugPrint(error)
                    completion(nil, .failedRequest)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse)
                    return
                }
                guard response.statusCode == 200 else {
                    debugPrint(response.statusCode)
                    completion(nil, .failedRequest)
                    return
                }
                guard let data else {
                    completion(nil, .noData)
                    return
                }

                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(result, nil)
                } catch {
                    debugPrint(error)
                    completion(nil, .invalidData)
                }
            }
        }
    }
}
