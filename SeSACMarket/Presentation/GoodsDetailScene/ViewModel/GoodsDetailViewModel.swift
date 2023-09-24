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
    func willDeinit()
}

protocol GoodsDetailViewModelOutput {
    var goods: Goods { get }
    var isFavoriteEnrolled: BehaviorRelay<Bool> { get }
}

protocol GoodsDetailViewModel: GoodsDetailViewModelInput,
                               GoodsDetailViewModelOutput, Coordinating { }

final class DefaultGoodsDetailViewModel: GoodsDetailViewModel {

    // MARK: - Usecase

    private let favoriteShoppingUseCase: FavoriteShoppingUseCase

    // MARK: - Coordinator

    weak var coordinator: Coordinator?

    // MARK: - Dependency Injection

    init(favoriteShoppingUseCase: FavoriteShoppingUseCase, goods: Goods) {
        self.favoriteShoppingUseCase = favoriteShoppingUseCase
        self.goods = goods
    }

    // MARK: - Output

    let goods: Goods
    let isFavoriteEnrolled: BehaviorRelay<Bool> = BehaviorRelay(value: false)

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

    func willDeinit() {
        coordinator?.eventOccurred(with: .deinited)
    }
}
