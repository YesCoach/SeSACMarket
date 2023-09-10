//
//  DateFormatter+.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation

extension NumberFormatter {

    static let format = {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        return format
    }()

    static func convertData(number: Int) -> String? {
        return format.string(from: NSNumber(value: number))
    }

}
