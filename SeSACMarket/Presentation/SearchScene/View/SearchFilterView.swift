//
//  SearchFilterView.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/09.
//

import UIKit

final class SearchFilterView: UIView {

    // MARK: - UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 6.0
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

    // MARK: - Properties

    private let typeList = APIEndPoint.NaverAPI.QueryType.SortType.allCases
    var completion: ((APIEndPoint.NaverAPI.QueryType.SortType) -> Void)?

    // MARK: - Initializer

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

// MARK: - Methods

extension SearchFilterView {

    /// 검색시 적용되는 정렬 타입을 초기화 하기 위해 호출합니다. 초기화시 '정확도'(=sim)으로 설정됩니다.
    func resetSortType() {
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource

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

        if indexPath.item == 0 {
            cell.isSelected = true
            cell.didSelected()
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.isSelected = false
            cell.didSelected()
        }

        cell.configure(with: typeList[indexPath.item])

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension SearchFilterView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? SearchFilterCollectionViewCell
        else { return }

        cell.didSelected()
        completion?(typeList[indexPath.item])
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

// MARK: - UICollectionViewDelegateFlowLayout

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
