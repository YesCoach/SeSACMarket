//
//  SearchCollectionViewCell.swift
//  SeSACMarket
//
//  Created by 박태현 on 2023/09/07.
//

import UIKit
import Kingfisher

final class SearchCollectionViewCell: BaseCollectionViewCell {

    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.image = .init(systemName: "home")
        imageView.layer.cornerRadius = Constants.Design.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .black
        button.backgroundColor = .white
        // todo: 버튼 cornerRadius를 원으로 적용하기
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()

    private lazy var mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemBackground
        label.text = "새싹몰"
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.backgroundColor = .systemBackground
        label.numberOfLines = 2
        label.text = "맥북"
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.text = "10000000원"
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }

    override func configureUI() {
        super.configureUI()
        contentView.clipsToBounds = true
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
            $0.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(contentView)
        }
    }
}

extension SearchCollectionViewCell {
    func configureMock() {
        thumbnailImageView.image = .init(systemName: "house")!
        mallNameLabel.text = "새싹몰"
        titleLabel.text = "상품명"
        priceLabel.text = "1233141242142141421"
    }

    func configure(with data: Goods) {
        if let imageURLString = data.image, let imageURL = URL(string: imageURLString) {
            thumbnailImageView.kf.setImage(with: imageURL)
        }
        mallNameLabel.text = data.mallName
        titleLabel.text = data.title
        priceLabel.text = data.lowPrice
    }
}
