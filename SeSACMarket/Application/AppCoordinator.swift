//
//  AppCoordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/21.
//

import UIKit

final class AppCoordinator: Coordinator {

    var tabBarController: UITabBarController?
    var childCoordinators: [Coordinator] = []
    private let appDIContainer: AppDIContainer

    init(
        appDIContainer: AppDIContainer,
        tabBarController: UITabBarController
    ) {
        self.appDIContainer = appDIContainer
        self.tabBarController = tabBarController
    }

    // 화면 전환 로직
    func start() {
        setTabBarController()
    }

    // 탭바 컨트롤러 구성 with coordinators
    private func setTabBarController() {

        let searchCoordinator = SearchCoordinator(
            dependencies: appDIContainer.makeSearchSceneDIContainer()
        )
        searchCoordinator.parentCoordinator = self
        childCoordinators.append(searchCoordinator)

        let searchViewController = searchCoordinator.startPush()
        searchViewController.tabBarItem = ContentViewControllers.search.tabBarItem

        let favoriteCoordinator = FavoriteCoordinator()
        favoriteCoordinator.parentCoordinator = self
        childCoordinators.append(favoriteCoordinator)

        let favoriteViewController = favoriteCoordinator.startPush()
        favoriteViewController.tabBarItem = ContentViewControllers.favorite.tabBarItem

        tabBarController?.viewControllers = [searchViewController, favoriteViewController]
    }

    func eventOccurred(with type: Event) { }

}

enum ContentViewControllers: Int, CaseIterable {
    case search
    case favorite

    var tabBarItem: UITabBarItem {
        switch self {
        case .search:
            let tabBarItem = UITabBarItem(
                title: "검색",
                image: .init(systemName: "magnifyingglass"),
                tag: 0
            )
            return tabBarItem
        case .favorite:
            let tabBarItem = UITabBarItem(
                title: "좋아요",
                image: .init(systemName: "heart"),
                tag: 0
            )
            return tabBarItem
        }
    }

}
