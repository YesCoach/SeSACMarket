//
//  GoodsDetailViewModel.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import Foundation
import RxSwift
import RxRelay

protocol GoodsDetailViewModelInput {
    func likeButtonDidTouched(isSelected: Bool)
    func viewWillAppear()
}

protocol GoodsDetailViewModelOutput {
    var goods: Goods { get }
    var isFavoriteEnrolled: BehaviorRelay<Bool> { get }
}

protocol GoodsDetailViewModel: GoodsDetailViewModelInput, GoodsDetailViewModelOutput {

}

final class DefaultGoodsDetailViewModel: GoodsDetailViewModel {

    private let favoriteShoppingUseCase: FavoriteShoppingUseCase
    let goods: Goods

    init(favoriteShoppingUseCase: FavoriteShoppingUseCase, goods: Goods) {
        self.favoriteShoppingUseCase = favoriteShoppingUseCase
        self.goods = goods
    }

    let isFavoriteEnrolled: BehaviorRelay<Bool> = .init(value: false)

}

// MARK: - GoodsDetailViewModelInput

extension DefaultGoodsDetailViewModel {

    func likeButtonDidTouched(isSelected: Bool) {
        if isSelected {
            favoriteShoppingUseCase.enrollFavoriteGoods(goods: goods)
        } else {
            favoriteShoppingUseCase.removeFavoriteGoods(goods: goods)
        }
    }

    func viewWillAppear() {
        isFavoriteEnrolled.accept(favoriteShoppingUseCase.isFavoriteEnrolled(goods: goods))
    }
}
