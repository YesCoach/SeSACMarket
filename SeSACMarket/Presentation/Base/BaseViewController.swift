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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NetworkCheckManager.shared.completion = { [weak self] isNetworkNotWork in
            if isNetworkNotWork {
                DispatchQueue.main.async { [self] in
                    self?.presentAlert(
                        title: "네트워크 연결 오류!",
                        message: "네트워크 연결 상태를 확인해주세요"
                    )
                }
            }
        }

    }

    func configureUI() { }

    func configureLayout() { }

    deinit {
        print("🗑️", String(describing: self), "- deinit success")
    }

}
