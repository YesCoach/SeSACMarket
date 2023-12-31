//
//  AppDIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

final class AppDIContainer {

    static let shared = AppDIContainer()

    private init() { }

    // MARK: - DIContainers
    func makeDIContainer() -> DIContainer {
        let dependencies = DIContainer.Dependencies(networkManager: .shared)

        return DIContainer(dependencies: dependencies)
    }

    // MARK: - DIContainers of scenes

    func makeSearchSceneDIContainer() -> SearchSceneDIContainer {
        let dependencies = SearchSceneDIContainer.Dependencies(networkManager: .shared)

        return SearchSceneDIContainer(dependencies: dependencies)
    }

    func makeFavoriteScneneDIContainer() -> FavoriteSceneDIContainer {
        let dependencies = FavoriteSceneDIContainer.Dependencies(networkManager: .shared)

        return FavoriteSceneDIContainer(dependencies: dependencies)
    }

    func makeGoodsDetailSceneDIContainer() -> GoodsDetailSceneDIContainer {
        let dependencies = GoodsDetailSceneDIContainer.Dependencies(networkManager: .shared)

        return GoodsDetailSceneDIContainer(dependencies: dependencies)
    }

}
