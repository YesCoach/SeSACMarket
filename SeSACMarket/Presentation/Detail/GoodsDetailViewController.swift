//
//  GoodsDetailViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/10.
//

import UIKit
import WebKit
import RxSwift

final class GoodsDetailViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var likeButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.isSelected = viewModel.goods.favorite
        button.addTarget(self, action: #selector(likeButtonDidTouched(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .medium
        return view
    }()

    // MARK: - Properties

    private let viewModel: GoodsDetailViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(viewModel: GoodsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = viewModel.goods.productURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func configureUI() {
        self.title = viewModel.goods.title
        navigationItem.rightBarButtonItem = likeButton
    }

    override func configureLayout() {
        [
            webView, indicatorView
        ].forEach { view.addSubview($0) }
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}

extension GoodsDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.startAnimating()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicatorView.stopAnimating()
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        print(error.localizedDescription)
        indicatorView.stopAnimating()
        presentAlert(title: "페이지 로드 오류", message: "연결 상태를 확인해주세요!")
    }

}

private extension GoodsDetailViewController {

    @objc func likeButtonDidTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.likeButtonDidTouched(isSelected: sender.isSelected)
    }

    func bindViewModel() {
        viewModel.isFavoriteEnrolled
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isFavorite in
                guard let self else { return }
                if let button = likeButton.customView as? UIButton {
                    button.isSelected = isFavorite
                }
            }
            .disposed(by: disposeBag)
    }

}
