//
//  SearchFilterCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/09.
//

import UIKit

final class SearchFilterCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Components

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.layer.masksToBounds = true
        return label
    }()

    private(set) var filterType: APIEndPoint.NaverAPI.QueryType.SortType?

    // MARK: - Initializer

    override func configureUI() {
        label.textColor = isSelected ? .customWhiteBlack : .systemGray
        self.backgroundColor = isSelected ? .customBlackWhite : .systemBackground
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

// MARK: - Methods

extension SearchFilterCollectionViewCell {

    func configure(with filterType: APIEndPoint.NaverAPI.QueryType.SortType) {
        self.filterType = filterType
        label.text = filterType.description
    }

    func didSelected() {
        configureUI()
    }

    /// 셀의 사이즈 계산을 위한 메서드입니다.
    /// - Parameters:
    ///   - availableHeight: 셀의 높이
    ///   - type: 셀을 구성할 정렬 타입값
    /// - Returns: 정렬 타입의 텍스트를 가진 셀의 사이즈를 계산해서 반환합니다.
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
