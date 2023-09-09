//
//  SearchFilterView.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/09.
//

import UIKit

final class SearchFilterView: UIView {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SearchFilterCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchFilterCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false

        return collectionView
    }()

    private let typeList = APIEndPoint.NaverAPI.QueryType.SortType.allCases

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .systemBackground
    }

    private func configureLayout() {
        self.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SearchFilterView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return typeList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchFilterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchFilterCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(with: typeList[indexPath.item])

        return cell
    }

}

extension SearchFilterView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? SearchFilterCollectionViewCell
        else { return }

        cell.didSelected()
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? SearchFilterCollectionViewCell
        else { return }

        cell.didSelected()
    }

}

extension SearchFilterView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return SearchFilterCollectionViewCell.fittingSize(
            availableHeight: 30,
            type: typeList[indexPath.item]
        )
    }
}
