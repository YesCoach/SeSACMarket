//
//  SearchSceneDIContainer.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/24.
//

import Foundation

final class SearchSceneDIContainer: SearchCoordinatorDependencies {

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

    func makeShoppingRepository() -> ShoppingRepository {
        return DefaultShoppingRepository(networkManager: dependencies.networkManager)
    }

    func makeLocalShoppingRepository() -> LocalShoppingRepository {
        return DefaultLocalShoppingRepository(goodsStorage: goodsStorage)
    }

    func makeSearchHistoryRepository(
        type: UserDefaultsKey.SearchHistory
    ) -> SearchHistoryRepository {
        return DefaultSearchHistoryRepository(
            historyKey: type,
            searchHistoryStorage: searchHistoryStorage
        )
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

    func makeSearchHistoryUseCase(type: UserDefaultsKey.SearchHistory) -> SearchHistoryUseCase {
        return DefaultSearchHistoryUseCase(
            searchHistroyRepository: makeSearchHistoryRepository(type: type)
        )
    }

    // MARK: - ViewModel

    func makeSearchViewModel() -> SearchViewModel {
        return DefaultSearchViewModel(
            fetchShoppingUseCase: makeFetchShoppingUseCase(),
            favoriteShoppingUseCase: makeFavoriteShoppingUseCase(),
            searchHistoryUseCase: makeSearchHistoryUseCase(type: .search)
        )
    }

    // MARK: - ViewController

    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }

}
