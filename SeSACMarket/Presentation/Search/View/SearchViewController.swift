//
//  SearchViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import RxSwift
import RxRelay

final class SearchViewController: BaseViewController {

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
        collectionView.prefetchDataSource = self

        return collectionView
    }()

    private lazy var searchFilterView: SearchFilterView = {
        let view = SearchFilterView(frame: .zero)
        view.completion = { [weak self] type in
            self?.viewModel.filterDidSelected(with: type)
        }
        return view
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요!"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    // MARK: - Properties

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    private let spacing = Constants.Design.commonInset

    // MARK: - Initializer

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshViewController()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        self.title = "쇼핑 검색"
    }

    override func configureLayout() {
        super.configureLayout()

        [
            searchBar, searchFilterView, collectionView, emptyLabel
        ].forEach { view.addSubview($0) }

        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        searchFilterView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchFilterView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(collectionView)
        }
    }

    @objc private func keyboardReturnButtonDidTouched() {

    }

}

private extension SearchViewController {

    func bindViewModel() {
        viewModel.itemList
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

    func searchShoppingItem(with keyword: String) {
        viewModel.searchShoppingItem(with: keyword)
        searchFilterView.resetSortType()
    }
}

// MARK: - UISearchBarDelegate 구현부

extension SearchViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchShoppingItem(with: searchBar.text!)
    }
}

// MARK: - UICollectionViewDataSource 구현부

extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let count = try? viewModel.itemList.value().count
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

        guard let data = try? viewModel.itemList.value()
        else { return UICollectionViewCell() }

        cell.configure(with: data[indexPath.item]) { [weak self] (data, isFavorite) in
            guard let self else { return }
            viewModel.likeButtonDidTouched(with: data, isFavorite: isFavorite)
        }

        return cell
    }

}

// MARK: - UICollectionViewDelegate 구현부

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemList = try? viewModel.itemList.value() else { return }
        let viewController = AppDIContainer()
            .makeDIContainer()
            .makeGoodsDetailViewController(goods: itemList[indexPath.item])
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        print(#function)
        viewModel.prefetchItemsAt(indexPaths: indexPaths)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        print(#function)
    }
}
