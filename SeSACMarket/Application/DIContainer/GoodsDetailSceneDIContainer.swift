//
//  GoodsDetailSceneDIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/25.
//

import Foundation

final class GoodsDetailSceneDIContainer: GoodsDetailCoordinatorDependencies {

    struct Dependencies {
        let networkManager: NetworkManager
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Persistentr Storage

    lazy var goodsStorage: GoodsStorage = RealmGoodsStorage(realmStorage: .shared)

    // MARK: - Repository

    func makeLocalShoppingRepository() -> LocalShoppingRepository {
        return DefaultLocalShoppingRepository(goodsStorage: goodsStorage)
    }

    // MARK: - UseCase

    func makeFavoriteShoppingUseCase() -> FavoriteShoppingUseCase {
        return DefaultFavoriteShoppingUseCase(
            localShoppingRepository: makeLocalShoppingRepository()
        )
    }

    // MARK: - ViewModel

    func makeGoodsDetailViewModel(goods: Goods) -> GoodsDetailViewModel {
        return DefaultGoodsDetailViewModel(
            favoriteShoppingUseCase: makeFavoriteShoppingUseCase(),
            goods: goods
        )
    }

    // MARK: - ViewController

    func makeGoodsDetailViewController(goods: Goods) -> GoodsDetailViewController {
        return GoodsDetailViewController(viewModel: makeGoodsDetailViewModel(goods: goods))
    }

}
