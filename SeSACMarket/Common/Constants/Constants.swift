//
//  Constants.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import Foundation

enum Constants {

    enum Design {

        static let commonInset: CGFloat = 10.0
        static let cornerRadius: CGFloat = 5.0

    }

    enum API {

        static let searchIdxLimit = 1000

    }

    enum NotificationName {

        static let viewWillAppearWithTabBar = NSNotification.Name("viewWillAppearWithTabBar")

    }
}
