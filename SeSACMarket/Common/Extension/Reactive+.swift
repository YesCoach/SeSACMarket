//
//  Reactive+.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/12.
//

import UIKit
import RxSwift

extension Reactive where Base: UICollectionView {
    var topToWithAnimation: Binder<Bool> {
        return Binder(self.base) { collectionView, isAnimation in
            collectionView.setContentOffset(.zero, animated: isAnimation)
        }
    }
}

extension Reactive where Base: UIViewController {
    var presentAlertController: Binder<(String?, String?)> {
        return Binder(self.base) { viewController, alertContent in
            viewController.presentAlert(title: alertContent.0, message: alertContent.1)
        }
    }
}

extension Reactive where Base: SearchFilterView {
    var resetSortType: Binder<Bool> {
        return Binder(self.base) { view, _ in
            view.resetSortType()
        }
    }
}

extension Reactive where Base: UISearchBar {
    var resignFirstResponder: Binder<Bool> {
        return Binder(self.base) { searchBar, _ in
            searchBar.resignFirstResponder()
        }
    }
}
