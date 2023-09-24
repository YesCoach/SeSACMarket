//
//  Coordinator.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/21.
//

import UIKit

enum Event {
    case deinited
    case itemSelected(item: Goods)
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func childDidFinish(_ coordinator: Coordinator)
    func eventOccurred(with type: Event)
}

protocol Coordinating: AnyObject {
    var coordinator: Coordinator? { get set }
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, coordinator) in childCoordinators
            .enumerated() where coordinator === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
