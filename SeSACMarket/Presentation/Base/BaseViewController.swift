//
//  BaseViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    func configureUI() { }

    func configureLayout() { }

    deinit {
        print("🗑️", String(describing: self), "- deinit success")
    }

}
