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
    func viewWillDisappear()
    func searchShoppingItem(with keyword: String)
    func searchBarCancleButtonClicked()
    func searchBarSearchButtonClicked()
    func searchBarTextDidChange(with text: String)
}

protocol FavoriteViewModelOutput {
    var favoriteItemList: BehaviorSubject<[Goods]> { get }
    var isEmptyLabelHidden: BehaviorRelay<Bool> { get }
    var resignKeyboard: BehaviorRelay<Bool> { get }
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
    let resignKeyboard: BehaviorRelay<Bool> = .init(value: false)

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

    func viewWillDisappear() {
        resignKeyboard.accept(true)
    }

    func searchShoppingItem(with keyword: String) {
        self.keyword = keyword
        loadFavoriteShoppingItems()
    }

    func searchBarCancleButtonClicked() {
        resignKeyboard.accept(true)
    }

    func searchBarSearchButtonClicked() {
        resignKeyboard.accept(true)
    }

    func searchBarTextDidChange(with text: String) {
        let trimmedText = text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        searchShoppingItem(with: trimmedText)
    }
}

// MARK: - Private Methods

private extension DefaultFavoriteViewModel {

    func loadFavoriteShoppingItems() {
        guard let keyword, keyword != "" else {
            let itemList = favoriteShoppingUseCase.readFavoriteGoodsData()
            isEmptyLabelHidden.accept(!itemList.isEmpty)
            favoriteItemList.onNext(itemList)
            return
        }
        let itemList = favoriteShoppingUseCase.searchFavoriteGoods(keyword: keyword)
        isEmptyLabelHidden.accept(!itemList.isEmpty)
        favoriteItemList.onNext(itemList)
    }

}
