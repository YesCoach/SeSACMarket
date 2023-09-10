//
//  TabBarController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit

final class TabBarController: UITabBarController {

    enum ContentViewControllers: CaseIterable {
        case search
        case favorite

        var initiate: UIViewController {
            switch self {
            case .search: return AppDIContainer().makeDIContainer().makeSearchViewController()
            case .favorite: return AppDIContainer().makeDIContainer().makeFavoriteViewController()
            }
        }

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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewControllers()
    }

}

private extension TabBarController {

    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.view.tintColor = .systemBlack
    }

    func configureViewControllers() {
        let viewControllers: [UIViewController] = ContentViewControllers.allCases.map {
            let viewController = UINavigationController(rootViewController: $0.initiate)
            viewController.tabBarItem = $0.tabBarItem
            return viewController
        }
        self.viewControllers = viewControllers
    }

}
