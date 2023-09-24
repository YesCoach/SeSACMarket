//
//  GoodsDetailCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/22.
//

import UIKit
import OSLog

final class GoodsDetailCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private var goods: Goods
    var navigationController: UINavigationController

    init(goods: Goods, navigationController: UINavigationController) {
        self.goods = goods
        self.navigationController = navigationController
    }

    deinit {
        if #available(iOS 14.0, *) {
            Logger.coordinatorLogger.log("🗑️ \(String(describing: self)) deinit success")
        } else {
            os_log("🗑️ %@ deinit success", log: .coordinatorLogger, String(describing: self))
        }
    }

    func start() {
        let goodsDetailViewController = AppDIContainer.shared
            .makeDIContainer()
            .makeGoodsDetailViewController(goods: goods)
        goodsDetailViewController.coordinator = self
        navigationController.pushViewController(goodsDetailViewController, animated: true)
    }

    func eventOccurred(with type: Event) {
        switch type {
        case .deinited:
            parentCoordinator?.childDidFinish(self)
        default: return
        }
    }

}
