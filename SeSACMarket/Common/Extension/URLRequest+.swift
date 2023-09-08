//
//  URLRequest+.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import Foundation

extension URLRequest {

    /// URLRequest의 헤더를 설정 / 반환 합니다.
    /// set - 딕셔너리 타입의 헤더를 설정하면, 해당 딕셔너리에 맞게 HTTPHeaderField를 초기화합니다.
    /// get - 현재 URLRequest의 모든 HTTPHeaderFields 값을 딕셔너리 형태로 반환합니다.
    var httpHeader: [String: String]? {
        get {
            return self.allHTTPHeaderFields
        }
        set {
            guard let newValue else { return }
            newValue.forEach { (key, value) in
                addValue(value, forHTTPHeaderField: key)
            }
        }
    }
}
