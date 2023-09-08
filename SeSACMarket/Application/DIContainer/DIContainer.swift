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

    // MARK: - Repository

    func makeShoppingRepository() -> ShoppingRepository {
        return DefaultShoppingRepository(networkManager: dependencies.networkManager)
    }

    // MARK: - UseCase

    func makeFetchShoppingUseCase() -> FetchShoppingUseCase {
        return DefaultFetchShoppingUseCase(shoppingRepository: makeShoppingRepository())
    }

    // MARK: - ViewModel

    func makeSearchViewModel() -> SearchViewModel {
        return DefaultSearchViewModel(fetchShoppingUseCase: makeFetchShoppingUseCase())
    }

    // MARK: - VIewController

    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }
}
