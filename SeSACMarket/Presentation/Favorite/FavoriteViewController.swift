//
//  FavoriteViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import RxSwift

final class FavoriteViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.searchTextField.addTarget(
            self,
            action: #selector(keyboardReturnButtonDidTouched),
            for: .editingDidEndOnExit
        )
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in

            let spacing = Constants.Design.commonInset

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            var group: NSCollectionLayoutGroup

            if #available(iOS 16.0, *) {
                group = .horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
                group.interItemSpacing = .fixed(spacing)
            } else {
                group = .horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(spacing)
            }
            group.contentInsets = .init(
                top: spacing,
                leading: spacing,
                bottom: spacing,
                trailing: spacing
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0

            return section
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag

        return collectionView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "찜한 상품이 없어요!"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    // MARK: - Properties

    private let viewModel: FavoriteViewModel
    private let disposeBag = DisposeBag()
    private let spacing = Constants.Design.commonInset

    // MARK: - Initializer

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: Constants.NotificationName.viewWillAppearWithTabBar,
            object: nil
        )
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(collectionViewScrollToTop),
            name: Constants.NotificationName.viewWillAppearWithTabBar,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        self.title = "좋아요 목록"
    }

    override func configureLayout() {
        super.configureLayout()

        [
            searchBar, collectionView, emptyLabel
        ].forEach { view.addSubview($0) }

        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(collectionView)
        }
    }

    @objc private func keyboardReturnButtonDidTouched() {

    }

    @objc private func collectionViewScrollToTop() {
        collectionView.setContentOffset(.init(x: 0, y: 0), animated: false)
    }

}

// MARK: - Private Methods

private extension FavoriteViewController {

    func bindViewModel() {
        viewModel.favoriteItemList
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                collectionView.reloadData()
            }
            .disposed(by: disposeBag)

        viewModel.isEmptyLabelHidden
            .subscribe { [weak self] in
                guard let self else { return }
                emptyLabel.isHidden = $0
            }
            .disposed(by: disposeBag)
    }

    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

}

// MARK: - UISearchBarDelegate 구현부

extension FavoriteViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.searchShoppingItem(with: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        viewModel.searchShoppingItem(with: searchBar.text!)
    }

}

// MARK: - UICollectionViewDataSource 구현부

extension FavoriteViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let count = try? viewModel.favoriteItemList.value().count
        return count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchCollectionViewCell
        else { return UICollectionViewCell() }

        guard let data = try? viewModel.favoriteItemList.value()
        else { return UICollectionViewCell() }

        cell.configure(with: data[indexPath.item]) { [weak self] (data, isFavorite) in
            guard let self else { return }
            viewModel.likeButtonDidTouched(with: data, isFavorite: isFavorite)
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate 구현부

extension FavoriteViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemList = try? viewModel.favoriteItemList.value() else { return }
        let viewController = AppDIContainer()
            .makeDIContainer()
            .makeGoodsDetailViewController(goods: itemList[indexPath.item])
        navigationController?.pushViewController(viewController, animated: true)
    }

}
