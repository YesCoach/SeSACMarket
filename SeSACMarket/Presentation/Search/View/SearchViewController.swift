//
//  SearchViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class SearchViewController: BaseViewController {

    // MARK: - UI Components

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ in

            let spacing = Constants.Design.commonInset

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(1.0)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.55)
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
        collectionView.refreshControl = refreshControl
        collectionView.keyboardDismissMode = .onDrag

        return collectionView
    }()

    private lazy var searchHistoryView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SearchHistoryCell.self,
            forCellReuseIdentifier: SearchHistoryCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true

        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(viewControllerDidRefresh(_:)),
            for: .valueChanged
        )
        return refreshControl
    }()

    private lazy var searchFilterView: SearchFilterView = {
        let view = SearchFilterView(frame: .zero)
        view.completion = { [weak self] type in
            guard let self else { return }
            viewModel.filterDidSelected(with: type)
        }
        return view
    }()

    private lazy var upScrollButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "arrow.up.circle.fill"), for: .normal)
        button.addTarget(
            self,
            action: #selector(upScrollButtonDidTouched(_:)),
            for: .touchUpInside
        )
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.cornerRadius = 25.0
        button.layer.masksToBounds = true
        button.tintColor = .customBlackWhite
        button.alpha = 0
        return button
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
    private var upScrollButtonFlag = true

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
        viewModel.viewWillAppear()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        self.title = "쇼핑 검색"
    }

    override func configureLayout() {
        super.configureLayout()

        [
            searchBar, searchFilterView, collectionView,
            emptyLabel, searchHistoryView, upScrollButton
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
        searchHistoryView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        upScrollButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.height.equalTo(50)
        }
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}

// MARK: - Private Methods

private extension SearchViewController {

    // MARK: - Bind

    func bindViewModel() {
        viewModel.itemList
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                collectionView.reloadData()
            }
            .disposed(by: disposeBag)

        viewModel.searchHistoryList
            .subscribe { [weak self] _ in
                guard let self else { return }
                searchHistoryView.reloadData()
            }
            .disposed(by: disposeBag)

        viewModel.isRefreshControlRefreshing
            .asDriver()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.error
            .asSignal()
            .emit(to: self.rx.presentAlertController)
            .disposed(by: disposeBag)

        viewModel.isSearchHistoryHidden
            .asDriver()
            .drive(searchHistoryView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isUpScrollButtonHidden
            .asDriver()
            .drive(upScrollButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isEmptyLabelHidden
            .asDriver()
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isFilterViewHidden
            .bind(to: searchFilterView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isFilterTypeReset
            .asDriver()
            .drive(searchFilterView.rx.resetSortType)
            .disposed(by: disposeBag)

        viewModel.resignKeyboard
            .asDriver()
            .drive(searchBar.rx.resignFirstResponder)
            .disposed(by: disposeBag)

        viewModel.scrollToTopWithAnimation
            .asSignal()
            .emit(to: collectionView.rx.topToWithAnimation)
            .disposed(by: disposeBag)
    }

    func searchShoppingItem(with keyword: String) {
        viewModel.searchShoppingItem(with: keyword)
    }

    // MARK: - Action

    @objc func viewControllerDidRefresh(_ sender: UIRefreshControl) {
        viewModel.refreshViewController()
    }

    @objc func upScrollButtonDidTouched(_ sender: UIButton) {
        viewModel.upScrollButtonDidTouched()
    }

}

// MARK: - UISearchBarDelegate 구현부

extension SearchViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        viewModel.searchBarTextDidBeginEditing()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        viewModel.searchBarTextDidEndEditing()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchBarSearchButtonClicked(text: searchBar.text!)
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

extension SearchViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let screen = view.window?.windowScene?.screen else { return }
        let height = screen.bounds.height

        if scrollView.contentSize.height - scrollView.contentOffset.y < height * 2 {
            viewModel.fetchNextShoppingList()
        }

        if scrollView.contentOffset.y > height {
            if upScrollButtonFlag == true {
                upScrollButtonFlag = false
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self else { return }
                    upScrollButton.alpha = 1
                }
            }
        } else {
            if upScrollButtonFlag == false {
                upScrollButtonFlag = true
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self else { return }
                    upScrollButton.alpha = 0
                }
            }
        }
    }

}

// MARK: - UITableViewDataSource(Search History)

extension SearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let historyList = try? viewModel.searchHistoryList.value() {
            return historyList.count
        } else { return 0 }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchHistoryCell.reuseIdentifier,
            for: indexPath
        ) as? SearchHistoryCell
        else { return UITableViewCell() }

        guard let keyword = try? viewModel.searchHistoryList.value()[indexPath.row]
        else { return UITableViewCell() }
        cell.configure(with: keyword)

        return cell
    }

}

// MARK: - UITableViewDelegate(Search History)

extension SearchViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, _ in
            guard let self else { return }
            viewModel.searchHistoryDelete(index: indexPath.row)
        }

        delete.backgroundColor = .systemRed
        delete.image = .init(systemName: "trash")

        return .init(actions: [delete])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.searchHistoryDidSelect(index: indexPath.row)
    }
}
