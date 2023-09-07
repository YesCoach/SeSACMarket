//
//  SearchCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {

    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        return button
    }()

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemBackground
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.backgroundColor = .systemBackground
        label.numberOfLines = 2
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.backgroundColor = .systemBackground
        return label
    }()

    override func configureUI() {
        super.configureUI()
        contentView.backgroundColor = .systemBackground
    }

    override func configureLayout() {
        super.configureLayout()
        [
            thumbnailImageView, likeButton, mallNameLabel, titleLabel, priceLabel
        ].forEach { contentView.addSubview($0) }

        thumbnailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width)
        }
        likeButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.bottom.equalTo(thumbnailImageView).inset(4)
        }
        mallNameLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallNameLabel)
            $0.horizontalEdges.equalToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(contentView)
        }
    }
}
