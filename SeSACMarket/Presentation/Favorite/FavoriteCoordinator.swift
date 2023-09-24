//
//  FavoriteCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/23.
//

import UIKit
import OSLog

protocol FavoriteCoordinatorDependencies {
    func makeFavoriteViewController() -> FavoriteViewController
    func makeFavoriteViewModel() -> FavoriteViewModel
}

final class FavoriteCoordinator: Coordinator {

    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let dependencies: FavoriteCoordinatorDependencies
    private lazy var viewModel = dependencies.makeFavoriteViewModel()

    init(
        navigationController: UINavigationController = UINavigationController(),
        dependencies: FavoriteCoordinatorDependencies
    ) {
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

    func eventOccurred(with type: Event) {
        switch type {
        case .deinited: return
        case .itemSelected(let item):
            let goodsDetailCoordinator = GoodsDetailCoordinator(
                goods: item,
                navigationController: navigationController
            )
            goodsDetailCoordinator.parentCoordinator = self
            childCoordinators.append(goodsDetailCoordinator)
            goodsDetailCoordinator.start()
        }
    }

    func start() { }

    // 본인이 담당하는 ViewController 객체를 생성하여 반환
    func startPush() -> UINavigationController {
        viewModel.coordinator = self

        let viewController = FavoriteViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)

        return navigationController
    }

}
