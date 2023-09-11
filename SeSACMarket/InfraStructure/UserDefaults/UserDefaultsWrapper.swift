//
//  UserDefaultsWrapper.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}
