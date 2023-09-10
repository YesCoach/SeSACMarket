//
//  RealmMapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

protocol RealmMapping {
    associatedtype DomainType

    func toDomain() -> DomainType
}
