//
//  DTOMapping.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

protocol DTOMapping: Codable {
    associatedtype DomainType

    func toDomain() -> DomainType
}
