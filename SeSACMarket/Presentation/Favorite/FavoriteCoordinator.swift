//
//  FavoriteCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/23.
//

import UIKit
import OSLog

final class FavoriteCoordinator: Coordinator {

    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []

    // for depth
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
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
        let viewController = AppDIContainer.shared.makeDIContainer().makeFavoriteViewController()
        // todo: DI 여기서 구현해주기
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)

        return navigationController
    }

}
