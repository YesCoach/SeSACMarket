//
//  SearchFilterCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/09.
//

import UIKit

final class SearchFilterCollectionViewCell: BaseCollectionViewCell {

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.layer.masksToBounds = true
        return label
    }()

    private(set) var filterType: APIEndPoint.NaverAPI.QueryType.SortType?

    override func configureUI() {
        label.textColor = isSelected ? .black : .systemGray

        self.backgroundColor = isSelected ? .white : .systemBackground
        self.layer.borderWidth = isSelected ? .zero : 1.0
        self.layer.cornerRadius = Constants.Design.cornerRadius
        self.layer.masksToBounds = true
        setNeedsLayout()
    }

    override func configureLayout() {
        super.configureLayout()

        contentView.addSubview(label)

        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.systemGray.cgColor
    }

}

extension SearchFilterCollectionViewCell {

    func configure(with filterType: APIEndPoint.NaverAPI.QueryType.SortType) {
        self.filterType = filterType
        label.text = filterType.description
    }

    func didSelected() {
        configureUI()
    }

    static func fittingSize(
        availableHeight: CGFloat,
        type: APIEndPoint.NaverAPI.QueryType.SortType
    ) -> CGSize {
        let cell = SearchFilterCollectionViewCell()
        cell.configure(with: type)

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: availableHeight
        )
        return cell
            .contentView
            .systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
    }

}
