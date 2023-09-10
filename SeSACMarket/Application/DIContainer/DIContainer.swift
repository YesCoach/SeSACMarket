//
//  DIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/08.
//

import Foundation

final class DIContainer {

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

    func makeShoppingRepository() -> ShoppingRepository {
        return DefaultShoppingRepository(networkManager: dependencies.networkManager)
    }

    func makeLocalShoppingRepository() -> LocalShoppingRepository {
        return DefaultLocalShoppingRepository(goodsStorage: goodsStorage)
    }

    // MARK: - UseCase

    func makeFetchShoppingUseCase() -> FetchShoppingUseCase {
        return DefaultFetchShoppingUseCase(shoppingRepository: makeShoppingRepository())
    }

    func makeFavoriteShoppingUseCase() -> FavoriteShoppingUseCase {
        return DefaultFavoriteShoppingUseCase(
            localShoppingRepository: makeLocalShoppingRepository()
        )
    }

    // MARK: - ViewModel

    func makeSearchViewModel() -> SearchViewModel {
        return DefaultSearchViewModel(
            fetchShoppingUseCase: makeFetchShoppingUseCase(),
            favoriteShoppingUseCase: makeFavoriteShoppingUseCase()
        )
    }

    func makeFavoriteViewModel() -> FavoriteViewModel {
        return DefaultFavoriteViewModel(favoriteShoppingUseCase: makeFavoriteShoppingUseCase())
    }

    func makeGoodsDetailViewModel(goods: Goods) -> GoodsDetailViewModel {
        return DefaultGoodsDetailViewModel(
            favoriteShoppingUseCase: makeFavoriteShoppingUseCase(),
            goods: goods
        )
    }

    // MARK: - VIewController

    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }

    func makeFavoriteViewController() -> FavoriteViewController {
        return FavoriteViewController(viewModel: makeFavoriteViewModel())
    }

    func makeGoodsDetailViewController(goods: Goods) -> GoodsDetailViewController {
        return GoodsDetailViewController(viewModel: makeGoodsDetailViewModel(goods: goods))
    }
}
