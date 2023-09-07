//
//  SearchViewController.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit

final class SearchViewController: BaseViewController {

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
                heightDimension: .fractionalHeight(0.45)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: spacing)

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.contentInsets = .init(
                top: spacing,
                leading: spacing,
                bottom: spacing,
                trailing: 0
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            return section
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    private let spacing = Constants.Design.commonInset

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        self.title = "쇼핑 검색"
    }

    override func configureLayout() {
        super.configureLayout()

        [
            searchBar, collectionView
        ].forEach { view.addSubview($0) }

        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc private func keyboardReturnButtonDidTouched() {

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
        return 10
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

        cell.configureMock()
        return cell
    }

}

// MARK: - UICollectionViewDelegate 구현부

extension SearchViewController: UICollectionViewDelegate {


}
