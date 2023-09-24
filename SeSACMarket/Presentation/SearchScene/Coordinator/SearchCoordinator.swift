//
//  SearchCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/21.
//

import UIKit
import OSLog

protocol SearchCoordinatorDependencies {
    func makeSearchViewController() -> SearchViewController
    func makeSearchViewModel() -> SearchViewModel
}

final class SearchCoordinator: Coordinator {

    // 부모 코디네이터
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    private let dependencies: SearchCoordinatorDependencies
    private lazy var viewModel = dependencies.makeSearchViewModel()

    init(
        navigationController: UINavigationController = UINavigationController(),
        dependencies: SearchCoordinatorDependencies
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

    func start() { }

    // 본인이 담당하는 ViewController 객체를 생성하여 반환
    func startPush() -> UINavigationController {
        viewModel.coordinator = self

        let viewController = SearchViewController(viewModel: viewModel)

        navigationController.setViewControllers([viewController], animated: false)
        return navigationController
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

}
