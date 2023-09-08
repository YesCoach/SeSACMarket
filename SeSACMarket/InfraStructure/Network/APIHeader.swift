//
//  APIHeader.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

enum APIHeader {

    enum NaverAPI {

        /// NaverAPI request에 필요한 헤더 구성입니다.
        ///
        /// **X-Naver-Client-Id**: 등록된 APIKey의 ID
        ///
        /// **X-Naver-Client-Secret**: 등록된 APIKey의 SecretKey
        static let header: [String: String] = [
            "X-Naver-Client-Id": "\(APIKey.NaverAPIKey.clientID)",
            "X-Naver-Client-Secret": "\(APIKey.NaverAPIKey.clientSecret)"
        ]
    }
}
