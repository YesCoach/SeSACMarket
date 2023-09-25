//
//  GoodsDetailCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/22.
//

import UIKit
import OSLog

protocol GoodsDetailCoordinatorDependencies {
    func makeGoodsDetailViewController(goods: Goods) -> GoodsDetailViewController
    func makeGoodsDetailViewModel(goods: Goods) -> GoodsDetailViewModel
}

final class GoodsDetailCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let goods: Goods
    private let navigationController: UINavigationController
    private let dependencies: GoodsDetailCoordinatorDependencies
    private lazy var viewModel = dependencies.makeGoodsDetailViewModel(goods: goods)

    init(
        goods: Goods,
        navigationController: UINavigationController,
        dependencies: GoodsDetailCoordinatorDependencies
    ) {
        self.goods = goods
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    deinit {
        if #available(iOS 14.0, *) {
            Logger.coordinatorLogger.log("🗑️ \(String(describing: self)) deinit success")
        } else {
            os_log("🗑️ %@ deinit success", log: .coordinatorLogger, String(describing: self))
        }
    }

    func start() {
        viewModel.coordinator = self

        let viewController = GoodsDetailViewController(viewModel: viewModel)

        navigationController.pushViewController(viewController, animated: true)
    }

    func eventOccurred(with type: Event) {
        switch type {
        case .deinited:
            parentCoordinator?.childDidFinish(self)
        default: return
        }
    }

}
