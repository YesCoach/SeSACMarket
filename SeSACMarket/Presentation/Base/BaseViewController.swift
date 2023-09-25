//
//  BaseViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import SnapKit
import OSLog

class BaseViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 14.0, *) {
            Logger.uiLogger.log("✅ \(String(describing: self)) init success")
        } else {
            os_log("✅ %@ init success", log: .uiLogger, String(describing: self))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        if #available(iOS 14.0, *) {
            Logger.uiLogger.log("🗑️ \(String(describing: self)) deinit success")
        } else {
            os_log("🗑️ %@ deinit success", log: .uiLogger, String(describing: self))
        }
    }

}
