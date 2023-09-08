//
//  AppDIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

final class AppDIContainer {

    // MARK: - DIContainers
    func makeDIContainer() -> DIContainer {
        let dependencies = DIContainer.Dependencies(networkManager: .shared)

        return DIContainer(dependencies: dependencies)
    }

}
