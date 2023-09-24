//
//  FavoriteSceneDIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/25.
//

import Foundation

final class FavoriteSceneDIContainer: FavoriteCoordinatorDependencies {

    struct Dependencies {
        let networkManager: NetworkManager
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Persistentr Storage

    lazy var goodsStorage: GoodsStorage = RealmGoodsStorage(realmStorage: .shared)
    lazy var searchHistoryStorage: SearchHistoryStorage = UserDefaultsSearchHistoryStorage()

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

    func makeFavoriteViewModel() -> FavoriteViewModel {
        return DefaultFavoriteViewModel(
            favoriteShoppingUseCase: makeFavoriteShoppingUseCase()
        )
    }

    // MARK: - ViewController

    func makeFavoriteViewController() -> FavoriteViewController {
        return FavoriteViewController(viewModel: makeFavoriteViewModel())
    }

}
