//
//  UIViewController+.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import UIKit

extension UIViewController {

    func presentAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)

        alert.addAction(action)
        present(alert, animated: true)
    }

}
