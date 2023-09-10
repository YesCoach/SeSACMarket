//
//  FavoriteViewModel.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation
import RxSwift
import RxRelay

protocol FavoriteViewModelInput {
    func likeButtonDidTouched(with data: Goods, isFavorite: Bool)
    func viewWillAppear()
    func searchShoppingItem(with keyword: String)
}

protocol FavoriteViewModelOutput {
    var favoriteItemList: BehaviorSubject<[Goods]> { get }
    var isEmptyLabelHidden: BehaviorRelay<Bool> { get }
}

protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }

final class DefaultFavoriteViewModel: FavoriteViewModel {

    private let favoriteShoppingUseCase: FavoriteShoppingUseCase

    // MARK: - DI

    init(favoriteShoppingUseCase: FavoriteShoppingUseCase) {
        self.favoriteShoppingUseCase = favoriteShoppingUseCase
    }

    // MARK: - FavoriteViewModelOutput

    let favoriteItemList: BehaviorSubject<[Goods]> = .init(value: [])
    let isEmptyLabelHidden: BehaviorRelay<Bool> = .init(value: false)

    private var keyword: String?
}

// MARK: - FavoriteViewModelInput

extension DefaultFavoriteViewModel {

    func likeButtonDidTouched(with data: Goods, isFavorite: Bool) {
        if isFavorite == false {
            favoriteShoppingUseCase.removeFavoriteGoods(goods: data)
            loadFavoriteShoppingItems()
        }
    }

    func viewWillAppear() {
        searchShoppingItem(with: keyword ?? "")
    }

    func searchShoppingItem(with keyword: String) {
        self.keyword = keyword
        guard keyword != "" else {
            loadFavoriteShoppingItems()
            return
        }
        let itemList = favoriteShoppingUseCase.searchFavoriteGoods(keyword: keyword)
        isEmptyLabelHidden.accept(!itemList.isEmpty)
        favoriteItemList.onNext(itemList)
    }

}

// MARK: - Private Methods

private extension DefaultFavoriteViewModel {

    func loadFavoriteShoppingItems() {
        let itemList = favoriteShoppingUseCase.readFavoriteGoodsData()
        isEmptyLabelHidden.accept(!itemList.isEmpty)
        favoriteItemList.onNext(itemList)
    }

}
