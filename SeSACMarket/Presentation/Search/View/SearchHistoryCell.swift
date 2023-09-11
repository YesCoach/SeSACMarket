//
//  SearchHistoryCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/11.
//

import UIKit

final class SearchHistoryCell: BaseTableViewCell {

    // MARK: - UI Components

    private lazy var recentImage: UIImageView = {
        let recentImage = UIImageView()
        recentImage.image = UIImage(systemName: "clock.arrow.circlepath")
        recentImage.tintColor = .systemGreen
        return recentImage
    }()

    private lazy var recentLabel: UILabel = {
        let recentLabel = UILabel()
        recentLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        recentLabel.textColor = .label
        return recentLabel
    }()

    override func configureLayout() {
        super.configureLayout()
        [
            recentImage, recentLabel
        ].forEach { contentView.addSubview($0) }

        let commonInset: CGFloat = 10.0

        recentImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(commonInset)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24.0)
            $0.width.equalTo(26.0)
        }
        recentLabel.snp.makeConstraints {
            $0.leading.equalTo(recentImage.snp.trailing).offset(commonInset)
            $0.top.trailing.bottom.equalToSuperview().inset(5.0)
        }
    }

}

extension SearchHistoryCell {

    func configure(with keyword: String) {
        recentLabel.text = keyword
    }

}
